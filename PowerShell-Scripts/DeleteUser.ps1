# Script : DeleteUser.ps1
# Purpose: Deletes a specific user within a specific Organization Unit based on user prompt.
# Why    : Easy and fast way for the Administrator to delete specific accounts.


# Prompt the user for the name of the user to delete
$name = Read-Host "Enter the name to delete"

# Prompt the user for the name of the Organizational Unit where the user is located
$ouName = Read-Host "Enter the name of the Organizational Unit where the user is located"


# Attempt to retrieve the Organizational Unit object from Active Directory
# If the Organizational Unit Name entered exits, for example 'Marketing', $ou = OU=Marketing,DC=net2grid,DC=globexpower,DC=com
$ou = Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue


# If the Organizational Unit object was found, check if the specified user exists in it and delete it if found
if ($ou) {

    $userDN = "CN=$name,$ou"

    try {
        $user = Get-ADUser -Identity $userDN -ErrorAction Stop
        Remove-ADObject -Identity $userDN -Recursive -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "User $name has been deleted from $ouName"
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        Write-Host "User $name was not found in $ouName"
    }

} else {

    Write-Host "Organizational Unit $ouName was not found"
   
    }
