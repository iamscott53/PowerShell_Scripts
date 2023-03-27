# Search for the group "Radius-Nokia-Full"
$group = Get-ADGroup -Filter { Name -eq "Radius-OPS-EqtAcces" }

# Get all the members of the group
$members = Get-ADGroupMember -Identity $group.DistinguishedName

# Create an array to hold the member information
$memberInfo = @()

# Loop through each member and get their information
foreach ($member in $members) {
    $user = Get-ADUser -Identity $member -Properties *
    $managerName = ""
    if ($user.Manager) {
        $manager = Get-ADUser -Identity $user.Manager -Properties DisplayName
        $managerName = $manager.DisplayName
    }
    $info = @{
        "SAMAccountName" = $user.SAMAccountName
        "Job Title" = $user.Title
        "Manager" = $managerName
        "Department" = $user.Department
        "Name" = $user.DisplayName
        "extensionAttribute4" = $user.extensionAttribute4
    }
    $memberInfo += New-Object PSObject -Property $info
}

# Export the member information to a CSV file
$memberInfo | Export-Csv -Path "C:\tmp\Radius-OPS-EqtAcces_updated.csv" -NoTypeInformation
