# Script : UploadCSVFileToGoogleSpreadSheet.ps1
# Purpose: Upload the CSV file to Google SpreadSheet
# Why    : It was necessary. NET2GRID already had a CSV file with user's information. In order to automate the process it was decided to developed this script.

Import-Module UMN-Google

$spreadsheetID = "<YOUR_SPREADSHEET_ID"

# import CSV
$import = New-Object System.Collections.ArrayList($null)

# build sheet header as it isn't included automatically
$import.Add( @("FirstName", "MiddleInitials", "LastName", "FullName", "SamAccountName", "Password", "DisplayName", "OU", "Office", "Email", "WebPage", "JobTitle", "Department", "Company", "MainPhone", "HomePhone", "MobilePhone", "Fax", "Street", "City", "State", "PostalCode")) | Out-Null

# build ArrayList
$inputCsv = Import-Csv "ADUsersInfo.csv"
$inputCsv | ForEach-Object { 
    $import.Add( @($_.FirstName, $_.MiddleInitials, $_.LastName, $_.FullName, $_.SamAccountName, $_.Password, $_.DisplayName, $_.OU, $_.Office, $_.Email, $_.WebPage, $_.JobTitle, $_.Department, $_.Company, $_.MainPhone, $_.HomePhone, $_.MobilePhone, $_.Fax, $_.Street, $_.City, $_.State, $_.PostalCode)) | Out-Null
}

# upload CSV data to Google Sheets with Set-GSheetData
# in this case the sheetName is "Users"
try {
    Set-GSheetData -accessToken $accessToken -rangeA1 "A1:V$($import.Count)" -sheetName "Users" -spreadSheetID $SpreadsheetID -values $import -Debug -Verbose
} catch {
    $err = $_.Exception
    $err | Select-Object -Property *
    "Response: "
    $err.Response
}
