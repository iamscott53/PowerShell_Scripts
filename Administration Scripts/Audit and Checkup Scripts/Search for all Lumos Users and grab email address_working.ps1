# Search for all Lumos Users and grab email address
$lumosusers = Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -filter * -Properties * | select -ExpandProperty mail 
Get-ADUser -Filter {proxyAddresses -contains }


# If email is @nscom.com then update to @lumosfiber.com
$bademail = "nscom"

$users = Get-Content C:\tmp\nscomemails.txt

$array = @()

foreach ($e in $users) {
    get-recipient $e | Select -expandproperty samAccountName

    $nsarray = [PSCustomObject]@{
        Name = get-recipient $e | Select -expandproperty Name
        samAccountName = get-recipient $e | Select -expandproperty samAccountName
    }
    $array += $nsarray
}
$nsarray | Export-Excel -path C:\tmp\nscomusers.csv

foreach ($e in $users) {
    
    if ($e -contains $bademail) {
        Get-ADUser -Filter $e -Properties *

        $nsarray = [PSCustomObject]@{
            Name = get-recipient $e | Select -expandproperty Name
            samAccountName = get-recipient $e | Select -expandproperty samAccountName
        }
        $array += $nsarray

    }

    
}