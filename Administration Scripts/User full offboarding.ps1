
function Offboard-Account {
    param (
    [Parameter (Mandatory = $true)]
	[string]$ticketnumber
    )
	
	# List of users to be disabled
$Users = Get-Content C:\tmp\offboarding.txt

## Get today's date
$date = Get-Date
	
	# Grab user info
	$duser = Get-ADUser -Identity $username -properties name,samaccountname,enabled
	
# Disable users in list
foreach ($duser in $Users) {
  Write-Host "User is: $duser`n" -ForegroundColor Green
  try {
  Set-ADUser -Identity $duser -Description "Separation on $date - $ticketnumber" -Enabled $false
  Write-Host "  $duser description set.`n" -ForegroundColor Green
  Write-Host "  $duser disabled.`n" -ForegroundColor LightGreen
  } catch {
    Write-Host "ERROR in SET USER" -ForegroundColor Red
  }
  
  # Remove groups from user account 
  try {
    $UserGroups = Get-ADPrincipalGroupMembership smiths | select name
	$UserGroups = Export-Excel -Path C:\tmp\$($duser)_groups.csv -AutoSize -AutoFilter
	Write-Host "Grabbing $duser groups: $($GroupOutput)" -ForegroundColor Green
	foreach ($group in $UserGroups) {
		Remove-ADPrincipalGroupMembership $duser -member $group  -confirm:$false -ErrorAction Stop
		Write-Host "removing $($duser) from $group" -ForegroundColor green
        Write-Output "User $($duser) removed from $group "
	}
  } catch {
    Write-Host "ERROR in REMOVING GROUPS" -ForegroundColor Red
  }
}

}
Offboard-Account


$UserGroups = Get-ADUser -Identity smiths -Properties MemberOf
$UserGroups = Export-Excel -Path C:\tmp\$User.csv -AutoSize -AutoFilter