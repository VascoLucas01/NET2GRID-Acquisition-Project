# Script : PopulateActiveDirectoryStretchGoal.ps1
# Purpose: Through a token and a spreadsheetID it is possible to access a google spreadsheet to retrieve users' information
# Why    : Stretch goal of the AddUserOU_AD.ps1 script
Import-Module UMN-Google
 
 [CmdletBinding()]
param (
)

Write-Verbose "Starting script PopulateActiveDirectoryStretchGoal.ps1 ..."

$accessToken= "<YOUR_ACCESS_TOKEN>"
$spreadsheetID = "<YOUR_SPREADSHEET_ID"
$range = "Users!A1:V"

# Call Get-GSheetData to retrieve all the data from the "Users" sheet
$data = Get-GSheetData -accessToken $accessToken -spreadSheetID $SpreadsheetID -sheetName "Users" -cell AllData

# Loop through each row of the data and access each element
foreach ($row in $data) {
    # Access each column of the current row by index
    
    $firstName      = $row.FirstName
    $middleInitials = $row.MiddleInitials
    $lastName       = $row.LastName
    $fullName       = $row.FullName
    $username       = $row.SamAccountName
    $password       = $row.Password
    $displayName    = $row.DisplayName
    $ou             = $row.OU
    $office         = $row.Office
    $email          = $row.Email
    $webPage        = $row.WebPage
    $jobTitle       = $row.JobTitle
    $department     = $row.Department
    $company        = $row.Company
    $mainPhone      = $row.MainPhone
    $homePhone      = $row.HomePhone
    $mobilePhone    = $row.MobilePhone
    $fax            = $row.Fax
    $street         = $row.Street
    $city           = $row.City
    $state          = $row.State
    $postalCode     = $row.PostalCode


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


    # if SamAccountName, FullName, Password or OU attributes are not filled in the spreadsheet no further action is taken
    if ([string]::IsNullOrEmpty($row.SamAccountName) -or [string]::IsNullOrEmpty($row.FullName) -or [string]::IsNullOrEmpty($row.Password) -or [string]::IsNullOrEmpty($row.OU)) {
        Write-Warning "User not added. SamAccountName, FullName, Password or OU attributes are possible empty."
    }
    
    # if the user exists 
    elseif ( Get-ADUser -Filter { SamAccountName -eq $username } ){
        Write-Warning "*****************  The user $username exists *****************"
    }
    
    # if the user not exists and every attribute mentioned above are filled correctly   
    else {

        # if the organizational unit exists
        if( Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" ){
             Write-Warning "*****************  The Organizational Unit $OU exists *****************"
        }
       
       # if the organizational unit not exists
        # Organizational Units' creation
        else{
             New-ADOrganizationalUnit -Name $OU -Path “DC=net2grid,DC=globexpower,DC=com” -Description “NET2GRID”
             Write-Host "The Organizational Unit $OU was created." -ForegroundColor yellow
        }
   
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

        $userCreated = New-ADUser @params -PassThru
        
        # if the user is created successfully
        if( $userCreated ){
            Write-Host "The user account $username was created." -ForegroundColor yellow
        }
        
        # if the user's creation went wrong
        else {
            Write-Warning "*****************  Something happen. The user was not created.  *****************"
        } 

    }

 
}



Write-Verbose "Ending script PopulateActiveDirectoryStretchGoal.ps1 ..."
