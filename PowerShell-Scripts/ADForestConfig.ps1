
# Stores Admin password for Safe Mode starts
$Password = Read-Host -Prompt   'Enter SafeMode Admin Password' -AsSecureString


# Creates Forest and makes server Domain Controller

$Net2grid = @{
CreateDnsDelegation = $false
DatabasePath = 'C:\Windows\NTDS'
DomainMode = 'WinThreshold'
DomainName = 'net2grid.globexpower.com'
DomainNetbiosName = 'NET2GRID'
ForestMode = 'WinThreshold'
InstallDns = $true
LogPath = 'C:\Windows\NTDS'
NoRebootOnCompletion = $true
SafeModeAdministratorPassword = $Password
SysvolPath = 'C:\Windows\SYSVOL'
Force = $true
}

Install-ADDSForest @Net2grid

# Restarts the server after completion

Restart-Computer
