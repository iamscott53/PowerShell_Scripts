function Extend-ADAccount {
    param (
    [Parameter (Mandatory = $true)]
    [string]$username
    )



    $date = Get-Date
	$daysToAdd = $date.AddDays(90)



    $info = Get-ADUser -Identity $username -properties name, samaccountname, accountExpirationDate
    Write-Host "`n------------------------------------------------`n" -f Gray
    Write-Host "Extending Expiration Date for user " -nonewline
    Write-Host "$($info.name) / $($info.samaccountname)`n" -f Cyan
    Write-Host "Current Expiration Date is: " -nonewline
    Write-Host "$($info.accountExpirationDate)`n" -f Cyan
    Set-ADAccountExpiration -Identity $username -DateTime $daysToAdd -Server ADDS-C1-DC02 -verbose
    $check = Get-ADUser -Identity $username -Properties name, accountExpirationDate -Server ADDS-C1-DC02
    Write-Host "New Expiration Date is: " -nonewline
    Write-Host "$($check.accountExpirationDate)" -f Green
    Write-Host "`n------------------------------------------------`n" -f Gray

}



$prompt = Read-Host "Enter AD username or (C) to cancel"



do {
Extend-ADAccount -username $prompt
$prompt = Read-Host "Enter AD username or (C) to cancel"
} while ($prompt -ne "C")