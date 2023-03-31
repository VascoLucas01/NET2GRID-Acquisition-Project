Import-Module UMN-Google

# Set security protocol to TLS 1.2 to avoid TLS errors
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Google API Authorization
$scope = "https://www.googleapis.com/auth/spreadsheets https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/drive.file"
$certPath = "<YOUR_PATH_TO_YOUR_CERTIFICATE_FILE>"
$iss = "<YOUR_SERVICE_ACCOUNTs_EMAIL_ADDRESS>"
$certPswd = "<YOUR_PRIVATE_KEY_PASSWORD>"
try {
    $accessToken = Get-GOAuthTokenService -scope $scope -certPath $certPath -certPswd $certPswd -iss $iss
} catch {
    $err = $_.Exception
    $err | Select-Object -Property *
    "Response: "
    $err.Response
}

