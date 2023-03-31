# Script : CreateGoogleSpreadSheet.ps1
# Purpose: It creates a Google SpreadSheet and a sheet
# Why    : It saves time.

# create new spreadsheet
$Title = "YOUR_SPREADSHEET_NAME"
$SpreadsheetID = (New-GSheetSpreadSheet -accessToken $accessToken -title $Title).spreadsheetId


# create new sheet
$Sheet = "YOUR_SHEET_NAME"
Add-GSheetSheet -accessToken $accessToken -sheetName $Sheet -spreadSheetID $SpreadsheetID
