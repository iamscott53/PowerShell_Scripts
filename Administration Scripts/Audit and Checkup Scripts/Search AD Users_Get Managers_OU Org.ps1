# Search AD for all users, list manager and active status with failure report

$adusers = Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -filter * -Properties *
$adcontractors = Get-ADUser -searchbase "OU=Vendor Accounts,DC=LumosNet,DC=com" -filter * -Properties *

$fteoutput = @()
$ftefailure = @()
$contactoroutput = @()
$contractorfailure = @()

$admintext = New-ConditionalText admin yellow
$disabledtext = New-ConditionalText disable cyan

Foreach($user in $adusers)
{
    if($user.manager)
    {
        $mname = Get-ADUser -Filter {DistinguishedName -eq $user.Manager} -Properties *
        $userobj = [PSCustomObject]@{
            Name = $user.Name
            DN = $user.DistinguishedName
            UserEnabled = $user.Enabled
            Manager = $user.Manager
            ManagerName = $mname.Name
            ManagerEnabled = $mname.Enabled
        }
        $fteoutput += $userobj

    }
    else {
        $fail = [PSCustomObject]@{
            Name = $user.name
            Samaccountname = $user.samAccountName
            UserEnabled = $user.Enabled
            Manager = $user.Manager
        }
        $ftefailure += $fail
    }
}
$fteoutput | Export-Excel -Path C:\tmp\ad\managers\FTEandManagers.csv -AutoSize -AutoFilter -ConditionalText $admintext, $disabledtext
$ftefailure | Export-Excel -Path C:\tmp\ad\managers\FTENoManagers.csv -AutoSize -AutoFilter -ConditionalText $admintext, $disabledtext

Foreach($user in $adcontractors)
{
    if($user.manager)
    {
        $mname = Get-ADUser -Filter {DistinguishedName -eq $user.Manager} -Properties *
        $userobj = [PSCustomObject]@{
            Name = $user.Name
            DN = $user.DistinguishedName
            UserEnabled = $user.Enabled
            Manager = $user.Manager
            ManagerName = $mname.Name
            ManagerEnabled = $mname.Enabled
        }
        $contactoroutput += $userobj

    }
    else {
        $fail = [PSCustomObject]@{
            Name = $user.name
            Samaccountname = $user.samAccountName
            UserEnabled = $user.Enabled
            Manager = $user.Manager
        }
        $contractorfailure += $fail
    }
}
$contactoroutput | Export-Excel -Path C:\tmp\ad\managers\ContractorsAndManagers.csv -AutoSize -AutoFilter -ConditionalText $admintext, $disabledtext
$contractorfailure | Export-Excel -Path C:\tmp\ad\managers\ContractorsNoManagers.csv -AutoSize -AutoFilter -ConditionalText $admintext, $disabledtext