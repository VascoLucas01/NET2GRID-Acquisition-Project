# Script : Windows10Config.ps1
# Purpose: Assigns a new IPv4 address to the machine as well as DNS and joins to the domain of NET2GRID.
# Why    : It saves time. 



# Powershell script that assigns a new IPv4 address to the machine as well as DNS.

# Set the IP address, prefix length, adapter, and default gateway
$ip = '192.168.2.20'
$prefix = '24'
$adapterindex = (Get-NetAdapter).InterfaceIndex # Get the Interface Index of the first network adapter
$gateway = '192.168.2.1'
$dns = '192.168.2.10'

Write-Output "What interface do you want to release the IP addresses?"`n

# Shows the user all the available adapters
Get-NetAdapter

# Asks the user the interface to remove the IP addresses
$interface = Read-Host `n"Enter (1 or 2) 1 - Ethernet, 2 - Wireless"
switch ($interface) {
    "1" {
        if (Get-NetAdapter -Name "Ethernet" -ErrorAction SilentlyContinue) {
            Get-NetAdapter | Where-Object {$_.InterfaceAlias -eq "Ethernet"} | Remove-NetIPAddress
            Get-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 | Remove-NetRoute
            # Configure the IP address on the adapter
            New-NetIPAddress -IPAddress $ip -PrefixLength $prefix -InterfaceAlias Ethernet -DefaultGateway $gateway
            # Configure DNS on the same Interface
            Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dns
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
          # Configure DNS on the same Interface
          Set-DnsClientServerAddress -InterfaceAlias Wireless -ServerAddresses $dns
        } else {
            Write-Warning "************ Adapter Wireless does not exist ************"
        }
    }
    Default { Write-Host "You did not choose any of the options" }
}

# Add Computer to Domain
Add-Computer -DomainName net2grid.globexpower.com -Credential Administrator -Restart
