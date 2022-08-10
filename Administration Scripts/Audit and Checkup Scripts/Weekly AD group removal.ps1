# Retrieve accounts  disabled since Lastweek with groups still on the account, find groups and remove them
# WARNING!!!  THIS WILL REMOVE GROUPS ON ALL DISABLED USER ACCOUNTS IT FINDS. I WOULD SUGGEST RUNNING THE
# SCRIPT IN BLOCKS SO YOU CAN SEE WHO WILL BE DISABLED AND REMOVE THEM FROM "duserswithgroups.txt" WHICH IS
# THE LIST OF USERS THAT THE SCRIPT WILL BE USING
# AS A FAILSAFE - IT DOES OUTPUT ALL USERS/GROUPS REMOVED

# Get current date
$grabDate = ((Get-Date).AddDays(-10)).Date

# Grab disabled users from past 7 days
$dusers = Get-ADUser -filter {enabled -eq $false -and whenChanged -gt $grabDate} -properties * | where { ($_.memberof | measure).count -gt 1} | select -ExpandProperty samaccountname -Unique
$dusersinfo = Get-ADUser -filter {enabled -eq $false -and whenChanged -gt $grabDate} -properties * | where { ($_.memberof | measure).count -gt 1} | select samaccountname,description -Unique
# Put disabled users in TXT file
$dusers | Out-File C:\tmp\ad\working\duserswithgroups.txt
$dusersinfo | Out-File C:\tmp\ad\working\duserswithgroupsinfo.txt

# Grab disabled users TXT File to remove groups
$users = Get-Content C:\tmp\ad\duserswithgroups.txt
Foreach ($user in $users){
	
    # Search for groups on user account and put them in TXT file
    (Get-AdUser -Identity $user -Properties MemberOf | select-object MemberOf).MemberOf | Out-File C:\tmp\ad\working\groupstoremove.txt -Append
    (Get-AdUser -Identity $user -Properties MemberOf | select-object MemberOf).MemberOf | Out-File "C:\tmp\ad\working\groupstoremove-$user.txt"
}

# File of groups to remove
$groups = Get-Content C:\tmp\ad\working\groupstoremove.txt

# Format the lists so they can be processed by the script
$groups | % {$group = $_;$group -replace "(CN=)(.*?),.*",'$2' } | Out-File C:\tmp\ad\working\groupstoremove.txt

$failures = @()
$UserTable = @()

# Use User and Group list and loop through to try and remove them
foreach ($user in $dusers) {
    # Array for groups
    $groups = @()
    (Get-AdUser -Identity $user -Properties MemberOf | select-object MemberOf).MemberOf | ForEach-Object {
        # Fix group names
        $groups += $_ -replace "(CN=)(.*?),.*", '$2'
        try {
            Remove-ADGroupMember -Identity $_ -Members $user -Verbose -confirm:$false
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
    $groups | Out-File C:\tmp\ad\working\"$($user.samaccountname)-offboarding.txt"
    $failures | Export-Excel C:\tmp\ad\working\DisabledGroupFailures.csv -AutoSize -AutoFilter
    $UserTable | Export-Excel C:\tmp\ad\working\DisabledUsersList.csv -AutoSize -AutoFilter
}
