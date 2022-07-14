# Retrieve accounts  disabled since Lastweek with groups still on the account, find groups and remove them

# Get current date
$grabDate = ((Get-Date).AddDays(-3)).Date

# Grab disabled users from past 7 days
$dusers = Get-ADUser -filter {enabled -eq $false -and whenChanged -gt $grabDate} -properties * | where { ($_.memberof | measure).count -gt 1} | select -ExpandProperty samaccountname -Unique
$dusersinfo = Get-ADUser -filter {enabled -eq $false -and whenChanged -gt $grabDate} -properties * | where { ($_.memberof | measure).count -gt 1} | select samaccountname,description -Unique
# Put disabled users in TXT file
$dusers | Out-File C:\tmp\ad\duserswithgroups.txt
$dusersinfo | Out-File C:\tmp\ad\duserswithgroupsinfo.txt

# Grab disabled users TXT File to remove groups
$users = Get-Content C:\tmp\ad\duserswithgroups.txt
Foreach ($user in $users){
	
    # Search for groups on user account and put them in TXT file
    (Get-AdUser -Identity $user -Properties MemberOf | select-object MemberOf).MemberOf | Out-File C:\tmp\ad\groupstoremove.txt -Append
    (Get-AdUser -Identity $user -Properties MemberOf | select-object MemberOf).MemberOf | Out-File C:\tmp\ad\groupstoremove-$user.txt
}

# File of groups to remove
$groups = Get-Content C:\tmp\ad\groupstoremove.txt

# Format the lists so they can be processed by the script
$groups | % {$group = $_;$group -replace "(CN=)(.*?),.*",'$2' } | Out-File C:\tmp\ad\groupstoremove.txt

$failures = @()
$UserTable = @()

# Use User and Group list and loop through to try and remove them
foreach ($user in $dusers) {
    # Array for groups
    $groups = @()
    $user.memberof | ForEach-Object {
        # Fix group names
        $groups += $_ -replace "(CN=)(.*?),.*", '$2'
        try {
            Remove-ADGroupMember -Identity $_ -Members $user -Verbose -confirm:$false -WhatIf
            Write-Host "Success: removed $($_) from $($user))" -f Green
            
            $userobj = [PSCustomObject]@{
                Name = $user.name
                Samaccountname = $user.samaccountname
                Description = $user.description
            }
            $UserTable += $userobj
        }
        catch {
            Write-Host "Failure: unable to remove $($_) from $($user))" -f Red

            $fail = [PSCustomObject]@{
                Name = $user.samaccountname
                Group = $_ -replace "(CN=)(.*?),.*", '$2'
            }
            $failures += $fail
        }
        finally {
            $Error.Clear()
        }
    }
    $groups | Out-File C:\tmp\ad\"$($user.samaccountname)-offboarding.txt"
    $failures | Export-Excel C:\tmp\ad\DisabledGroupFailures.csv -AutoSize -AutoFilter
    $UserTable | Export-Excel C:\tmp\ad\DisabledUsersList.csv -AutoSize -AutoFilter
}
