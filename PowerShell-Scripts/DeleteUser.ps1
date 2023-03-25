  # Script : DeleteUser.ps1
  # Purpose: Deletes a specific user within a specific Organization Unit based on user prompt.
  # Why    : Easy and fast way for the Administrator to delete specific accounts.

# Prompt the user for the name of the user to delete
$username = Read-Host "Enter the username to delete"

# Prompt the user for the name of the Organizational Unit where the user is located
$ouName = Read-Host "Enter the name of the Organizational Unit where the user is located"

# Attempt to retrieve the Organizational Unit object from Active Directory
$ou = Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue

# If the Organizational Unit object was found, delete the specified user from it
if ($ou) {
    $ouPath = $ou.DistinguishedName
    $userDN = "CN=$username,$ouPath"
    $user = Get-ADUser -Identity $userDN -ErrorAction SilentlyContinue
    if ($user) {
        Remove-ADObject -Identity $userDN -Recursive -Confirm:$false
        Write-Host "User $username has been deleted from $ouName"
    }
    else {
        Write-Host "User $username was not found in $ouName"
    }
}
else {
    Write-Host "Organizational Unit $ouName was not found"
}
