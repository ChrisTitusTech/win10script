#!/bin/bash

#
# This script is for Arch Linux to configure XRDP for enhanced session mode
#
# The configuration is adapted from the Ubuntu 16.04 script.
#

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

# Use Qi to check for exact package name
if ! pacman -Qi xrdp > /dev/null ; then
    echo 'xrdp not installed. Install xrdp.' >&2
    sudo pacman -Syu --needed --noconfirm base base-devel git

    # Create a build directory in tmpfs
    TMPDIR=$(mktemp -d)
    pushd "$TMPDIR" || exit

    ###############################################################################
    # XRDP
    #
    (
        git clone https://aur.archlinux.org/xrdp.git
        cd xrdp || exit
        makepkg -sri --noconfirm
    )
    ###############################################################################
    # XORGXRDP
    # Devel version, because release version includes a bug crashing gnome-settings-daemon
    (
        git clone https://aur.archlinux.org/xorgxrdp-devel-git.git
        cd xorgxrdp-devel-git || exit
        makepkg -sri --noconfirm
    )
    ###############################################################################

    #remove build directory
    rm -rf $TMPDIR
fi


###############################################################################
# Configure XRDP
#
systemctl enable xrdp
systemctl enable xrdp-sesman

# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
# use rdp security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# remove encryption validation.
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
# disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini
#
# sed -n -e 's/max_bpp=32/max_bpp=24/g' /etc/xrdp/xrdp.ini

# use the default lightdm x display
# sed -i_orig -e 's/X11DisplayOffset=10/X11DisplayOffset=0/g' /etc/xrdp/sesman.ini
# rename the redirected drives to 'shared-drives'
sed -i_orig -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini

# Change the allowed_users
echo "allowed_users=anybody" > /etc/X11/Xwrapper.config


#Ensure hv_sock gets loaded
if [ ! -e /etc/modules-load.d/hv_sock.conf ]; then
	echo "hv_sock" > /etc/modules-load.d/hv_sock.conf
fi

# Configure the policy xrdp session
cat > /etc/polkit-1/rules.d/02-allow-colord.rules <<EOF
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.color-manager.create-device" ||
         action.id == "org.freedesktop.color-manager.modify-profile" ||
         action.id == "org.freedesktop.color-manager.delete-device" ||
         action.id == "org.freedesktop.color-manager.create-profile" ||
         action.id == "org.freedesktop.color-manager.modify-profile" ||
         action.id == "org.freedesktop.color-manager.delete-profile") &&
        subject.isInGroup("users"))
    {
        return polkit.Result.YES;
    }
});
EOF

# Adapt the xrdp pam config
cat > /etc/pam.d/xrdp-sesman <<EOF
#%PAM-1.0
auth        include     system-remote-login
account     include     system-remote-login
password    include     system-remote-login
session     include     system-remote-login
EOF


###############################################################################
# .xinitrc has to be modified manually.
#
echo "You will have to configure .xinitrc to start your windows manager, see https://wiki.archlinux.org/index.php/Xinit"
echo "Reboot your machine to begin using XRDP."