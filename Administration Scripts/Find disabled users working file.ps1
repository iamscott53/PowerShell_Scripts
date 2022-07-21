$query = Get-ADUser -Filter {name -like $user -or samaccountname -like $user} -properties Name,SamAccountName,Enabled

$ADUsers = Get-Content C:\tmp\projects\ad\dynamicsUsers.txt

$output = @()

foreach ($sysuser in $query) {
    Write-Host "Checking $($sysuser.samaccountname)" -f Green
    if ($sysuser.Enabled) { $status = "Enabled" } else {$status = "Disabled"}

    $Enabled = [PSCustomObject]@{
        Username      = $($sysuser.samaccountname)
        Role           = $status
    }

    $output += $Enabled


}
$output | export-csv C:\tmp\ad\dynamicsUsersResults.csv

##########################

$users = ForEach ($email in $(Get-Content C:\tmp\projects\ad\systemsfull\fsemails.txt)) {
	Try{

    Get-AdUser -Filter "EmailAddress -eq '$email'" -Properties name,samaccountname,EmailAddress,enabled
    }
	Catch
        {write-warning "$($email) doesnt have an AD account"}
} 
$users |
Select-Object SamAccountName,Enabled |
Export-Excel -Path C:\tmp\projects\ad\systemsfull\FSUsersResults.csv -AutoSize -AutoFilter

###

$content = Get-Content C:\tmp\projects\wizard\wizardemails.txt

foreach ($emails in $content)

{

    $command = "get-aduser  -Filter {emailaddress -eq ""$emails""} | select -ExpandProperty SamAccountName"

    Invoke-Expression $command

}

##


#### Check to ensure users are not enabled in AD ########
$users = Get-ADUser -Filter * -Properties enabled

foreach ($user in $users) {
Get-ADUser -Filter {name -like $user -or samaccountname -like $user} -properties Enabled
}



###############
$users = Get-Content C:\tmp\projects\ad\dynamicsUsers.txt
foreach ($user in $users){ 
	Get-ADUser -Filter {
		name -like $user -or samaccountname -like $user
		} | Select Name, SamAccountName,Enabled | Out-File -append C:\tmp\projects\ad\UserResults.txt
	}  
	
	
	| Select Name,SamAccountName,Enabled
Get-ADGroup -filter * -searchbase "OU=FileShares,OU=Groups,DC=LumosNet,DC=com" -properties members, managedby, description
