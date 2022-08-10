$output = @()


$users = Get-Content C:\tmp\ad\dynamicsUsers2.txt

foreach ($user in $users) {
    $q = Get-ADUser $user -properties * 

        $Enabled = [PSCustomObject]@{
            Username      = $user
            Active          = $q.Enabled
            Name          = $q.Name
            Company       = $q.Company
        }
        $output += $Enabled
        Write-Host "Found User $($user)"

}


$output | Export-Excel -Path C:\tmp\ad\dynamicsUsers2.csv -AutoSize -AutoFilter