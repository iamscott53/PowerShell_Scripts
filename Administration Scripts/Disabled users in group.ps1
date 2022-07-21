$groupname = "O365_Lic_E5"
$users = Get-ADGroupMember -Identity $groupname | ? {$_.objectclass -eq "user"}
foreach ($activeusers in $users) { Get-ADUser -Identity $activeusers | ? {$_.enabled -eq $false} | select Name, SamAccountName, UserPrincipalName, Enabled }