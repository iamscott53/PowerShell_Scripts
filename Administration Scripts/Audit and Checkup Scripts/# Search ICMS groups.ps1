# Search ICMS groups
$AS400 = Get-Content C:\tmp\as400.txt
$CLM200 = Get-Content C:\tmp\CommCoLM200.txt
$CLM400 = Get-Content C:\tmp\CommCoLM400.txt
$RICMS = Get-Content C:\tmp\ResiCoICMS.txt
$RLM200 = Get-Content C:\tmp\ResiCoLM200.txt
$RLM400 = Get-Content C:\tmp\ResiCoLM400.txt

# Arrays
$AS400array = @()
$CLM200array = @()
$CLM400array = @()
$RICMSarray = @()
$RLM200array = @()
$RLM400array = @()
$array1 = @()
$array2 = @()
$array3 = @()
$array4 = @()
$array5 = @()
$array6 = @()

# Check each group member's company
Write-Host "AS400 Users"
foreach ($user in $AS400) {
    
    $info1 = Get-ADUser $user -Properties * 

    $array1 = [PSCustomObject]@{
        Name = $info1.Name
        SamAccountName = $info1.samaccountname
        Company = $info1.Company
        UserEnabled = $info1.Enabled
    }
    $AS400array += $array1
}

Write-Host "CommCo LM200 Users"
foreach ($user in $CLM200) {
    
    $info2 = Get-ADUser $user -Properties *

    $array2 = [PSCustomObject]@{
        Name = $info2.Name
        SamAccountName = $info2.samaccountname
        Company = $info2.Company
        UserEnabled = $info2.Enabled
    }
    $CLM200array += $array2
}

Write-Host "CommCo LM400 Users"
foreach ($user in $CLM400) {
    
    $info3 = Get-ADUser $user -Properties *

    $array3 = [PSCustomObject]@{
        Name = $info3.Name
        SamAccountName = $info3.samaccountname
        Company = $info3.Company
        UserEnabled = $info3.Enabled
    }
    $CLM400array += $array3
}

Write-Host "ResiCo ICMS Users"
foreach ($user in $RICMS) {
    
    $info4 = Get-ADUser $user -Properties *

    $array4 = [PSCustomObject]@{
        Name = $info4.Name
        SamAccountName = $info4.samaccountname
        Company = $info4.Company
        UserEnabled = $info4.Enabled
    }
    $RICMSarray += $array4
}

Write-Host "ResiCo LM200 Users"
foreach ($user in $RLM200) {
    
    $info5 = Get-ADUser $user -Properties *

    $array5 = [PSCustomObject]@{
        Name = $info5.Name
        SamAccountName = $info5.samaccountname
        Company = $info5.Company
        UserEnabled = $info5.Enabled
    }
    $RLM200array += $array5
}

Write-Host "ResiCo LM400 Users"
foreach ($user in $RLM400) {
    
    $info6 = Get-ADUser $user -Properties *

    $array6 = [PSCustomObject]@{
        Name = $info6.Name
        SamAccountName = $info6.samaccountname
        Company = $info6.Company
        UserEnabled = $info6.Enabled
    }
    $RLM400array += $array6
}
$AS400array | Export-Excel -Path C:\tmp\AS400.csv -AutoSize -AutoFilter
$CLM200array | Export-Excel -Path C:\tmp\CLM200.csv -AutoSize -AutoFilter
$CLM400array | Export-Excel -Path C:\tmp\CLM400.csv -AutoSize -AutoFilter
$RICMSarray | Export-Excel -Path C:\tmp\RICMS.csv -AutoSize -AutoFilter
$RLM200array | Export-Excel -Path C:\tmp\RLM200.csv -AutoSize -AutoFilter
$RLM400array | Export-Excel -Path C:\tmp\RLM400.csv -AutoSize -AutoFilter