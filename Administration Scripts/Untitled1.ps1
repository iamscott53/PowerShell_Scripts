$today = Get-Date

# Find disabled user from email or empID

# List groups and save to file

# Disable User

# Set description to today's date

$Users = Get-Content C:\tmp\ad\users\offboarding.txt
foreach ($User in $Users) {
  Write-Host "User is: $User`n" -ForegroundColor Green
  try {
  Set-ADUser -Identity $User -Description "Separation on $today" -Enabled $false
  Write-Host "  $User description set.`n" -ForegroundColor Green
  Write-Host "  $User disabled.`n" -ForegroundColor LightGreen
  } catch {
    Write-Host "ERROR in SET USER" -ForegroundColor Red
  }
  try {
  $curgroups = (Get-AdUser -Identity $User -Properties MemberOf | select-object MemberOf).MemberOf
  Write-Host "  Groups for $User`n" -ForegroundColor Green
  $curgroups | Out-File C:\tmp\ad\users\offboarding.txt -Append
  try {
    $UserGroups = Get-ADUser -Identity $User -Properties MemberOf
    $GroupOutput = $UserGroups | select -ExpandProperty MemberOf | Get-ADGroup | select name
    Write-Host "Grabbing $User groups: $($GroupOutput)" -ForegroundColor Green
    $UserGroups.MemberOf | Remove-ADGroupMember -Member $User -Confirm:$false
    Write-Host "`n$User groups removed.`n" -ForegroundColor Green
  } catch {
    Write-Host "ERROR in REMOVE GROUPS" -ForegroundColor Red
  }
}