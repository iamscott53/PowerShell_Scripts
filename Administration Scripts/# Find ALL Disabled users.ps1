# Find ALL Disabled users
$users = Get-ADUser -Filter { enabled -eq $false } -Properties * 

$userinfo = @()

foreach ($user in $users) {

$userobj = [PSCustomObject]@{
    Name = $user.name
    Samaccountname = $user.samaccountname
    Description = $user.description
    Active = $user.Enabled
}
$userinfo += $userobj
}
$userobj 