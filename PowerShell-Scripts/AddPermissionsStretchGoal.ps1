# Script : AddPermissionsStretchGoal.ps1
# Purpose: Add access permissions to a user
# Why    : It saves time.


$SpreadsheetID = "<YOUR_SPREADSHEET_ID>"
$accessToken   = "<YOUR_ACCESS_TOKEN>"
Set-GFilePermissions -accessToken $accessToken -fileID $SpreadsheetID -role writer -type user -emailAddress 'example@example.com'
