$users = Get-Content "C:\Users\smiths\OneDrive - Segra\Documents\Scripts\tmp\users.txt"
$groups = Get-Content "C:\Users\smiths\OneDrive - Segra\Documents\Scripts\tmp\groups.txt"

Foreach ($group in $groups) {
Foreach ($user  in $users)  {
    Try{
        Remove-ADPrincipalGroupMembership $user -member $group  -confirm:$false -ErrorAction Stop
        Write-Host "removing $($user) from $group" -ForegroundColor green
        Write-Output "User $($user) removed from $group " 
    }
    
    Catch
        {write-warning "$_ Error removing user $($User) from $group"}
        }
    }