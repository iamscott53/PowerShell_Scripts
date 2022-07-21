get-content "C:\tmp\users.txt" |
Foreach {
    if (Get-ADUser -filter "Displayname -like '*$_*'" -ErrorAction SilentlyContinue)
        {Get-AdUser -filter "Displayname -like '*$_*'" -Properties samaccountname | select -exp samaccountname}
    else {Write-host "User\$_ does not exist in AD"}
     }