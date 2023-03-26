# Script : PopulateActiveDirectory.ps1
# Purpose: Manipulates the .csv file in order to add new users to the respective Organizational Unit
# Why : It saves time. Instead of insert an user one by one, the script can add a thousand of users at once.

[CmdletBinding()]
param (
    [Parameter(Mandatory=-$True)]
    [string]$filePath
)

Write-Verbose "Starting script PopulateActiveDirectory.ps1 ..."


# The variable ADUsersInfo stores the content of the file that is imported
$ADUsersInfo = Import-Csv $filePath -Delimiter ","

foreach ($User in $ADUsersInfo){
    # read information of each user in $ADUsersInfo
    $firstName      = $User.FirstName
    $middleInitials = $User.MiddleInitials
    $lastName       = $User.LastName
    $fullName       = $User.FullName
    $username       = $User.SamAccountName
    $password       = $User.Password
    $displayName    = $User.DisplayName
    $OU             = $User.OU
    $office         = $User.Office
    $email          = $User.Email
    $webPage        = $User.WebPage
    $jobTitle       = $User.JobTitle
    $department     = $User.Department
    $company        = $User.Company
    $mainPhone      = $User.MainPhone
    $homePhone      = $User.HomePhone
    $mobilePhone    = $User.MobilePhone
    $fax            = $User.Fax
    $streetAddress  = $User.Street
    $city           = $User.City
    $state          = $User.State
    $postalCode     = $User.PostalCode
    
    
Write-Verbose "--------------------------------------------------------------------------------"
Write-Verbose "First Name          : $firstName "
Write-Verbose "Middle Initials     : $middleInitials"
Write-Verbose "Last Name           : $lastName"
Write-Verbose "Full Name           : $fullName"
Write-Verbose "Username            : $username"
Write-Verbose "Password            : $password"
Write-Verbose "Display Name        : $displayName"
Write-Verbose "Organizational Unit : $OU"
Write-Verbose "Office              : $office"
Write-Verbose "Email               : $email"
Write-Verbose "Web Page            : $webPage"
Write-Verbose "Job Title           : $jobTitle"
Write-Verbose "Department          : $department"
Write-Verbose "Company             : $company"
Write-Verbose "Main Phone          : $mainPhone"
Write-Verbose "Home Phone          : $homePhone"
Write-Verbose "Mobile Phone        : $mobilePhone"
Write-Verbose "Fax                 : $fax"
Write-Verbose "Street Address      : $streetAddress"
Write-Verbose "City                : $city"
Write-Verbose "State               : $state"
Write-Verbose "Postal Code         : $postalCode"
Write-Verbose "--------------------------------------------------------------------------------"


# if the organizational unit exists
if( Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" ){

    Write-Warning "***************** The Organizational Unit $OU exists *****************"

}
# if the organizational unit not exists
# Organizational Units' creation
else{

    New-ADOrganizationalUnit -Name $OU -Path “DC=net2grid,DC=globexpower,DC=com” -Description “NET2GRID”
    Write-Host "The Organizational Unit $OU was created." -ForegroundColor yellow

}


# if the user exists
if( Get-ADUser -Filter { SamAccountName -eq $username } ){

    Write-Warning "***************** The user $username exists *****************"

}
# if the user not exists
# user's creation
else {

    $params = @{
        GivenName             = $firstName
        Initials              = $middleInitials
        Surname               = $lastName
        Name                  = $fullName
        SamAccountName        = $username
        AccountPassword       = (ConvertTo-secureString $password -AsPlainText -Force)
        ChangePasswordAtLogon = $True
        Enabled               = $True
        DisplayName           = $displayName
        Office                = $office
        EmailAddress          = $email
        HomePage              = $webPage
        Title                 = $jobTitle
        Department            = $department
        Company               = $company
        OfficePhone           = $mainPhone
        HomePhone             = $homePhone
        MobilePhone           = $mobilePhone
        Fax                   = $fax
        StreetAddress         = $streetAddress
        City                  = $city
        State                 = $state
        PostalCode            = $postalCode
        path                  = "OU=$ou, DC=NET2GRID, DC=globexpower, DC=com"
    }

    New-ADUser @params


    Write-Host "The user account $username was created." -ForegroundColor yellow

}


Write-Verbose "Ending script PopulateActiveDirectory.ps1 ..."

}
