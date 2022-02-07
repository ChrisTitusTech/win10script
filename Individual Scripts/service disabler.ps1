# Description:
#   This script disables unwanted Windows services. If you do not want to disable
#   certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service"      #Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                     #Diagnostics Tracking Service
    "dmwappushservice"                              #WAP Push Message Routing Service
    "lfsvc"                                         #Geolocation Service
    "MapsBroker"                                    #Downloaded Maps Manager
    "NetTcpPortSharing"                             #Net.Tcp Port Sharing Service
    "RemoteAccess"                                  #Routing and Remote Access
    "RemoteRegistry"                                #Remote Registry
    "SharedAccess"                                  #Internet Connection Sharing (ICS)
    "TrkWks"                                        #Distributed Link Tracking Client
    "WbioSrvc"                                      #Windows Biometric Service (Required for Fingerprint Reader / Facial Detection)
    #"WlanSvc"                                      #WLAN AutoConfig
    "WMPNetworkSvc"                                 #Windows Media Player Network Sharing Service
    #"wscsvc"                                       #Windows Security Center Service
    "WSearch"                                       #Windows Search
    "XblAuthManager"                                #Xbox Live Auth Manager
    "XblGameSave"                                   #Xbox Live Game Save Service
    "XboxNetApiSvc"                                 #Xbox Live Networking Service
    "XboxGipSvc"                                    #Xbox Accessory Management Service
    "ndu"                                           #Windows Network Data Usage Monitor
    "WerSvc"                                        #Windows error reporting
    "Spooler"                                       #Printing
    "Fax"                                           #Fax Service
    "fhsvc"                                         #Fax History
    "gupdate"                                       #Google Update
    "gupdatem"                                      #Disable Another Google Update Service
    "stisvc"                                        #Windows Image Acquisition (WIA)
    "AJRouter"                                      #Needed for AllJoyn Router Service
    "MSDTC"                                         #Distributed Transaction Coordinator
    "WpcMonSvc"                                     #Parental Controls
    "PhoneSvc"                                      #Phone Service (Manages the telephony state on the device)
    "PrintNotify"                                   #Windows printer notifications and extentions
    "PcaSvc"                                        #Program Compatibility Assistant Service
    "WPDBusEnum"                                    #Portable Device Enumerator Service
    #"LicenseManager"                               #Disable LicenseManager (Windows store may not work properly)
    "seclogon"                                      #Secondary Logon (disables other credentials only password will work)
    "SysMain"                                       #Analyses System Usage and Improves Performance
    "lmhosts"                                       #TCP/IP NetBIOS Helper
    "wisvc"                                         #Windows Insider Program (Windows Insider will not work if disabled)
    "FontCache"                                     #Windows Font Cache
    "RetailDemo"                                    #RetailDemo which is often used when showing your device
    "ALG"                                           #Application Layer Gateway Service (Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
    #"BFE"                                          #Base Filtering Engine (Manages firewall and Internet Protocol security)
    #"BrokerInfrastructure"                         #Windows infrastructure service that controls which background tasks can run on the system.
    "SCardSvr"                                      #Windows Smart Card Service
    "EntAppSvc"                                     #Enterprise Application Management.
    "BthAvctpSvc"                                   #AVCTP service (if you use Bluetooth Audio Device or Wireless Headphones. then don't disable this)
    #"FrameServer"                                  #Windows Camera Frame Server (Allows multiple clients to access video frames from camera devices.)
    "Browser"                                       #Let users browse and locate shared resources in neighboring computers
    "BthAvctpSvc"                                   #AVCTP service (This is Audio Video Control Transport Protocol service.)
    "BDESVC"                                        #Bitlocker Drive Encryption Service
    "iphlpsvc"                                      #ipv6 (Most websites use ipv4 instead)
    "edgeupdate"                                    #Edge Update Service
    "MicrosoftEdgeElevationService"                 #Another Edge Update Service 
    "edgeupdatem"                                   #Another Update Service
    "SEMgrSvc"                                      #Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
    #"PNRPsvc"                                      #Peer Name Resolution Protocol (Some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
    #"p2psvc"                                       #Peer Name Resolution Protocol (Enables multi-party communication using Peer-to-Peer Grouping. If disabled, some applications, such as HomeGroup, may not function. Discord will still work)
    #"p2pimsvc"                                     #Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly.Discord will still work)
    "PerfHost"                                      #Remote users and 64-bit processes to query performance.
    "BcastDVRUserService_48486de"                   #GameDVR and Broadcast is used for Game Recordings and Live Broadcasts
    "CaptureService_48486de"                        #Optional screen capture functionality for applications that call the Windows.Graphics.Capture API.
    "cbdhsvc_48486de"                               #Clipboard Service
    "BluetoothUserService_48486de"                  #Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.
    "WpnService"                                    #WpnService (Push Notifications may not work)
    #"StorSvc"                                      #StorSvc (USB external hard drive will not be recognized by Windows)
    "RtkBtManServ"                                  #Realtek Bluetooth Device Manager Service
    "QWAVE"                                         #Quality Windows Audio Video Experience (Audio and video might sound worse)
     #Hp Services
    "HPAppHelperCap"
    "HPDiagsCap"
    "HPNetworkCap"
    "HPSysInfoCap"
    "HpTouchpointAnalyticsService"
     #Hyper-v Services
    "HvHost"
    "vmickvpexchange"
    "vmicguestinterface"
    "vmicshutdown"
    "vmicheartbeat"
    "vmicvmsession"
    "vmicrdv"
    "vmictimesync" 
     #Services that cannot be disabled
    #"WdNisSvc"
)

foreach ($service in $services) {
    # -ErrorAction SilentlyContinue is so it doesn't write an error if a service doesn't exist

    Write-Host "Setting $service StartupType to Disabled"
    Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled

    $running = Get-Service -Name $service -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq 'Running'}
    if ($running) { 
        Write-Host "Stopping $service"
        Stop-Service -Name $service
    }
}
