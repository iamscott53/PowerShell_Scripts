$query = Get-ADGroup -filter * -searchbase "OU=FileShares,OU=Groups,DC=LumosNet,DC=com" -properties members, managedby, name, description

$output = @()

foreach ($fileshare in $query) {
    Write-Host "Checking $($fileshare.samaccountname)" -f Green
    if ($fileshare.managedby) { $owner = Get-ADUser $fileshare.managedby -properties company } else {$owner = $null}

    $managedby = [PSCustomObject]@{
        Fileshare      = $($fileshare.samaccountname)
		Description    = $($fileshare.description)
        Role           = "Owner"
        Name           = if ($owner) { $owner.name } else { "No_Manager_Found" }
        Samaccountname = if ($owner) { $owner.samaccountname } else { "No_Manager_Found" }
        Company        = if ($owner) { $owner.name } else { "No_Manager_Found" }
    }

    $output += $managedby

    $members = @()
    foreach ($user in $fileshare.members) {
        Write-Host "Checking $($user) - $($fileshare)"
        $account = Get-ADUser $user -properties company
        $data = [PSCustomObject]@{
            Fileshare      = $($fileshare.samaccountname)
			Description    = $($fileshare.description)
            Role           = "Member"
            Name           = $account.name
            Samaccountname = $account.samaccountname
            Company        = $account.company

        }
        $output += $data
    }
}