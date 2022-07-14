$query = Get-ADGroup -filter * -searchbase "OU=FileShares,OU=Groups,DC=LumosNet,DC=com" -properties members, managedby, description
$ADUsers = Get-ADUser -filter * -properties company

$output = @()

foreach ($fileshare in $query) {
    Write-Host "Checking $($fileshare.samaccountname)" -f Green
    if ($fileshare.managedby) { $owner = $ADUsers | Where-Object {$_.distinguishedname -eq $fileshare.managedby} } else {$owner = $null}

    $managedby = [PSCustomObject]@{
        Fileshare      = $($fileshare.samaccountname)
        Role           = "Owner"
        Description    = $fileshare.description
        Name           = if ($owner) { $owner.name } else { "No_Manager_Found" }
        Samaccountname = if ($owner) { $owner.samaccountname } else { "No_Manager_Found" }
        Company        = if ($owner) { $owner.name } else { "No_Manager_Found" }
    }

    $output += $managedby

    $members = @()
    foreach ($user in $fileshare.members) {
        Write-Host "Checking $($user) - $($fileshare)"
        $account = $ADUsers | Where-Object {$_.distinguishedname -eq $user}
        $data = [PSCustomObject]@{
            Fileshare      = $($fileshare.samaccountname)
            Role           = "Member"
            Description    = $null
            Name           = $account.name
            Samaccountname = $account.samaccountname
            Company        = $account.company

        }
        $output += $data
    }
}