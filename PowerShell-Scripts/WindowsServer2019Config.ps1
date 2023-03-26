  # Script : WindowsServer2019Config.ps1
  # Purpose: Assigns a static IPv4 address to the machine and renames it based on user input. Checks if DNS Server, Management Tools, NPAS and AD-DS are installed, if they are not, installs them including all ManagementTools and Subfeatures.
  # Why    : It saves time.
  
# Initialize the variables that contains the IP address, prefix, length, adapter, and default gateway to assign
$ip = '192.168.2.10'
$prefix = '24'
$gateway = '192.168.2.1'
Write-Output "What interface do you want to release the  IP addresses?"

# Shows the user all the available adapters
Get-NetAdapter

# Asks the user the interface to remove the IP addresses
$interface = Read-Host "Enter (1 or 2) 1 - Ethernet, 2 - Wireless"
switch ($interface) {
    "1" {
            if (Get-NetAdapter -Name "Ethernet" -ErrorAction SilentlyContinue) {
                Get-NetAdapter | Where-Object {$_.InterfaceAlias -eq "Ethernet"} | Remove-NetIPAddress
                Get-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 | Remove-NetRoute
                # Configure the IP address on the adapter
                New-NetIPAddress -IPAddress $ip -PrefixLength $prefix -InterfaceAlias Ethernet -DefaultGateway $gateway
                # Prompt the user for a new computer name and restart the computer with the new name
                $newname = Read-Host -Prompt 'Please give a new name for this computer '
                Rename-Computer -NewName $newname
            } else {
                Write-Warning "************ Adapter Ethernet does not exist ************"
            }
    }
    "2" {
            if (Get-NetAdapter -Name "Wireless" -ErrorAction SilentlyContinue) {
                Get-NetAdapter | Where-Object {$_.InterfaceAlias -eq "Wireless"} | Remove-NetIPAddress
                Get-NetRoute -InterfaceAlias Wireless -DestinationPrefix 0.0.0.0/0 | Remove-NetRoute
                # Configure the IP address on the adapter
                New-NetIPAddress -IPAddress $ip -PrefixLength $prefix -InterfaceAlias Wireless -DefaultGateway $gateway
                # Prompt the user for a new computer name and restart the computer with the new name
                $newname = Read-Host -Prompt 'Please give a new name for this computer '
                Rename-Computer -NewName $newname
            } else {
                Write-Warning "************ Adapter Wireless does not exist ************"
            }
    }
    Default { Write-Host "You did not choose any of the options" }
}

 # Checks if DNS Server, NPAS, ManagementTools, and AD-Domain-Services are installed
 $dnsServer = Get-WindowsFeature DNS
 $mgmtTools = Get-WindowsFeature RSAT-AD-Tools
 $adds = Get-WindowsFeature AD-Domain-Services
 $npas = Get-WindowsFeature NPAS
 
 # If DNS Server is not installed, install it
 if ($dnsServer.Installed -ne $true) {
  Write-Host "DNS Server is not installed. Installing..."
  Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools
  Write-Host "DNS Server is now installed"
 } else {
  Write-Warning "*********** DNS Server is already installed ***********"
 }
 # If ManagementTools are not installed, install it
 if ($mgmtTools.Installed -ne $true) {
  Write-Host "RSAT-AD-Tools (ManagementTools) is not installed. Installing..."
  Install-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature -IncludeManagementTools
  Write-Host "RSAT-AD-Tools (ManagementTools) is now installed"
 } else {
  Write-Warning "*********** RSAT-AD-Tools (ManagementTools) is already installed ***********"
 }
 # If ADDS is not installed, install it
 if ($adds.Installed -ne $true) {
  Write-Host "AD-Domain-Services is not installed. Installing..."
  Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
  Write-Host "AD-Domain-Services is now installed"
 } else {
  Write-Warning "*********** AD-Domain-Services is already installed ***********"
 }
  # If NPAS is not installed, install it
 if ($npas.Installed -ne $true) {
  Write-Host "NPAS is not installed. Installing..."
  Install-WindowsFeature -Name NPAS -IncludeAllSubFeature -IncludeManagementTools
  Write-Host "NPAS is now installed"
 } else {
  Write-Warning "*********** NPAS is already installed ***********"
 }
 
 Restart-Computer
