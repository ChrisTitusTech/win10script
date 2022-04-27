<#
.NOTES
   Author      : Chris Titus @christitustech
   GitHub      : https://github.com/ChrisTitusTech
    Version 0.0.1
#>

$inputXML = @"
<Window x:Class="WinUtility.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WinUtility"
        mc:Ignorable="d"
        Background="#777777"
        Title="Chris Titus Tech's Windows Utility" Height="450" Width="800">
    <Viewbox>
		<Grid Background="#777777" ShowGridLines="False" Name="MainGrid">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="3*"/>
            <ColumnDefinition Width="7*"/>
        </Grid.ColumnDefinitions>
        <StackPanel Background="#777777" SnapsToDevicePixels="True" Grid.Column="0">
            <Image Height="100" Width="170" Name="Icon" SnapsToDevicePixels="True" Source="https://github.com/ChrisTitusTech/win10script/raw/master/titus-toolbox.png" Margin="0,10,0,10"/>
            <Button Content="Install" VerticalAlignment="Top" Height="40" Background="#222222" BorderThickness="0,0,0,0" FontWeight="Bold" Foreground="#ffffff" Name="Tab1BT"/>
            <Button Content="Debloat" VerticalAlignment="Top" Height="40" Background="#333333" BorderThickness="0,0,0,0" FontWeight="Bold" Foreground="#ffffff" Name="Tab2BT"/>
            <Button Content="Config" VerticalAlignment="Top" Height="40" Background="#444444" BorderThickness="0,0,0,0" FontWeight="Bold" Foreground="#ffffff" Name="Tab3BT"/>
            <Button Content="Updates" VerticalAlignment="Top" Height="40" Background="#555555" BorderThickness="0,0,0,0" FontWeight="Bold" Foreground="#ffffff" Name="Tab4BT"/>
        </StackPanel>
        <TabControl Grid.Column="1" Padding="-1" Name="TabNav" SelectedIndex="0">
            <TabItem Header="Install" Visibility="Collapsed" Name="Tab1">
                <Grid Background="#222222">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="1*"/>
                        <ColumnDefinition Width="1*"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Background="#777777" SnapsToDevicePixels="True" Grid.Column="0" Margin="20">
						<Label Content="Browsers" FontSize="16"/>
                        <CheckBox Name="brave" Content="Brave"/>
                        <CheckBox Name="chrome" Content="Google Chrome"/>
                        <CheckBox Name="firefox" Content="Firefox"/>
						<Label Content="Document Tools" FontSize="16"/>
						<CheckBox Name="adobe" Content="Adobe Reader DC"/>
						<CheckBox Name="notepadplus" Content="Notepad++"/>
						<CheckBox Name="sumatra" Content="Sumatra PDF"/>
						<CheckBox Name="vscode" Content="VS Code"/>
						<CheckBox Name="vscodium" Content="VS Codium"/>
						<Label Content="Video and Image Tools" FontSize="16"/>
						<CheckBox Name="gimp" Content="GIMP (Image Editor)"/>
						<CheckBox Name="imageglass" Content="ImageGlass (Image Viewer)"/>
						<CheckBox Name="mpc" Content="Media Player Classic (Video Player)"/>
						<CheckBox Name="sharex" Content="ShareX (Screenshots)"/>
						<CheckBox Name="vlc" Content="VLC (Video Player)"/>
					</StackPanel>
					<StackPanel Background="#777777" SnapsToDevicePixels="True" Grid.Column="1" Margin="20">
						<Label Content="Utilities" FontSize="16"/>
						<CheckBox Name="terminal" Content="Windows Terminal"/>
						<CheckBox Name="powertoys" Content="Microsoft Powertoys"/>
						<CheckBox Name="sevenzip" Content="7-Zip"/>
						<CheckBox Name="autohotkey" Content="AutoHotkey"/>
						<CheckBox Name="discord" Content="Discord"/>
						<CheckBox Name="githubdesktop" Content="GitHub Desktop"/>
						<CheckBox Name="ttaskbar" Content="Translucent Taskbar"/>
						<CheckBox Name="etcher" Content="Etcher USB Creator"/>
						<CheckBox Name="putty" Content="Putty and WinSCP"/>
						<CheckBox Name="advancedip" Content="Advanced IP Scanner"/>
						<CheckBox Name="esearch" Content="Everything Search"/>
						<Button Name="install" Content="Start Install" Margin="20"/>
                        <ProgressBar Name="TitusPB" Height="10"/>
						</StackPanel>
					</Grid>
            </TabItem>
            <TabItem Header="Debloat" Visibility="Collapsed" Name="Tab2">
                <Grid Background="#333333">
                    <TextBlock HorizontalAlignment="Center" VerticalAlignment="Top" TextWrapping="Wrap" Text="Debloat" FontSize="14" FontWeight="Bold" Height="21" Foreground="#ffffff"/>
                </Grid>
            </TabItem>
            <TabItem Header="Config" Visibility="Collapsed" Name="Tab3">
                <Grid Background="#333333">
                    <TextBlock HorizontalAlignment="Center" VerticalAlignment="Top" TextWrapping="Wrap" Text="Config" FontSize="14" FontWeight="Bold" Height="21" Foreground="#ffffff"/>
                </Grid>
            </TabItem>
            <TabItem Header="Updates" Visibility="Collapsed" Name="Tab4">
                <Grid Background="#333333">
                    <TextBlock HorizontalAlignment="Center" VerticalAlignment="Top" TextWrapping="Wrap" Text="Updates" FontSize="14" FontWeight="Bold" Height="21" Foreground="#ffffff"/>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
    </Viewbox>
</Window>

"@
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch [System.Management.Automation.MethodInvocationException] {
    Write-Warning "We ran into a problem with the XAML code.  Check the syntax for this control..."
    write-host $error[0].Exception.Message -ForegroundColor Red
    if ($error[0].Exception.Message -like "*button*"){
        write-warning "Ensure your &lt;button in the `$inputXML does NOT have a Click=ButtonClick property.  PS can't handle this`n`n`n`n"}
}
catch{#if it broke some other way <img draggable="false" role="img" class="emoji" alt="😀" src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/svg/1f600.svg">
    Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
        }
 
#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables



#===========================================================================
# Navigation Controls
#===========================================================================

$WPFTab1BT.Add_Click({
    $WPFTabNav.Items[0].IsSelected = $true
    $WPFTabNav.Items[1].IsSelected = $false
    $WPFTabNav.Items[2].IsSelected = $false
    $WPFTabNav.Items[3].IsSelected = $false
})
$WPFTab2BT.Add_Click({
    $WPFTabNav.Items[0].IsSelected = $false
    $WPFTabNav.Items[1].IsSelected = $true
    $WPFTabNav.Items[2].IsSelected = $false
    $WPFTabNav.Items[3].IsSelected = $false
    })
$WPFTab3BT.Add_Click({
    $WPFTabNav.Items[0].IsSelected = $false
    $WPFTabNav.Items[1].IsSelected = $false
    $WPFTabNav.Items[2].IsSelected = $true
    $WPFTabNav.Items[3].IsSelected = $false
    })
$WPFTab4BT.Add_Click({
    $WPFTabNav.Items[0].IsSelected = $false
    $WPFTabNav.Items[1].IsSelected = $false
    $WPFTabNav.Items[2].IsSelected = $false
    $WPFTabNav.Items[3].IsSelected = $true
    })

#===========================================================================
# Install Tab1
#===========================================================================
$WPFinstall.Add_Click({
    $jobScript = { 
    If ( $WPFadobe.IsChecked -eq $true ) { 
        winget install -e --id Adobe.Acrobat.Reader.64-bit | Out-Host
    }
    If ( $WPFadvancedip.IsChecked -eq $true ) { 
        winget install -e Famatech.AdvancedIPScanner | Out-Host
    }
    If ( $WPFautohotkey.IsChecked -eq $true ) { 
        winget install -e Lexikos.AutoHotkey | Out-Host
    }
    Start-Sleep -s 3
  
    If ( $WPFbrave.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    If ( $WPFXXXXXX.IsChecked -eq $true ) { 
        
    }
    
}

Start-Job -Name InstallJobProgress -ScriptBlock $jobScript   
})

#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null