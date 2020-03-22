Import-Module Okta
 
$activeUsers = oktaListActiveUsers -oOrg prev

foreach ($user in $activeUsers)
{
    # Get factors for each user
    $factors = oktaGetFactorsbyUser -oOrg prev -uid $user.id

    # List factors details
    foreach ($factor in $factors)
    {
        $user.id + ", " + $user.profile.login + ", " + $user.profile.email + ", " + $user.profile.firstName + ", " + $user.profile.lastName + ", " + $factor.factorType + ", " + $factor.provider + ", " + $factor.status;
    }
}
