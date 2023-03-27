# Connect to Active Directory
Import-Module ActiveDirectory

# Set the search base to the "External Contractors" OU and set the scope to "OneLevel" to only include the OU and not child OUs
$searchBase = "OU=External Contractors,OU=Vendor Accounts,DC=LumosNet,DC=com"
$searchScope = "OneLevel"

# Search for all users in the "External Contractors" OU and put them into an array
$userArray = Get-ADUser -Filter * -SearchBase $searchBase -SearchScope $searchScope

# Create an empty array to hold the Lumos users
$lumosUsers = @()

foreach ($user in $userArray) {
    $user = Get-ADUser -Identity $user -Properties manager, displayname
    $managerName = ""
    if ($user.Manager) {
        $manager = Get-ADUser -Identity $user.Manager -Properties company
        # Check if the manager is in the "Lumos" company
        if ($manager.Company -eq "Lumos") {

        # If so, add the user to the Lumos users array
        $lumosUsers += $user.displayname
  }
    }
}

# Print out the Lumos users
$lumosUsers
