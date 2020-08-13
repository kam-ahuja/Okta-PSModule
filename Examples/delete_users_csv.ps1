$org = "https://TENANT.oktapreview.com"
$apikey = "API_KEY"

$headers = @{}
$baseUrl = ""
$userAgent = "OktaAPIWindowsPowerShell/0.1"

# Function to connect to Okta Org
function Connect-Okta($token, $baseUrl) {
    $script:headers = @{"Authorization" = "SSWS $token"; "Accept" = "application/json"; "Content-Type" = "application/json"}
    $script:baseUrl = "$baseUrl/api/v1"
}

# Shell for invoking a rest method
function Invoke-Method($method, $path, $body) {
    $url = $baseUrl + $path
    $jsonBody = ConvertTo-Json -compress $body
    Invoke-RestMethod $url -Method $method -Headers $headers -Body $jsonBody -UserAgent $userAgent
}

# Connect to Okta Org
Connect-Okta $apikey $org

# Get list of users from CSV
$users = import-csv "C:\users.csv"

foreach ($user in $users) {

    # Get user
    $oktaUser = Invoke-Method GET ("/users/" + $user.login)
    "Current State: " + $oktaUser.id + ", " + $oktaUser.status + ", " + $oktaUser.profile.login

    # Deactivate user
    "Deactivating " + $user.login
    Invoke-Method POST ("/users/" + $oktaUser.id + "/lifecycle/deactivate")
    "Deactivated " + $user.login

    # Delete user
    "Deleting " + $user.login
    Invoke-Method DELETE ("/users/" + $oktaUser.id)
    "Deleted " + $user.login
}

