# Search all Full time users for IT users
# All IT users = Under Rose Chambers
#
# Get-ADUser -LDAPFilter (Manager=[CN=Chambers\, Rose,OU=ITEmployees,OU=Employees,DC=LumosNet,DC=com]) -SearchBase "OU=Users,DC=contoso,DC=com" -Properties * | Select Name, SAMAccountName, @{n="ManagerName";e={(Get-ADUser $_.Manager).Name}}, @{n="ManagerEmail";e={(Get-ADUser $_.Manager -properties email).email}} | FL
#


$main = Get-ADUser -Filter { Manager -eq "CN=Chambers\, Rose,OU=ITEmployees,OU=Employees,DC=LumosNet,DC=com" } -Properties * | select -ExpandProperty DistinguishedName

foreach ($manager in $main) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level1.txt -Append
}
Foreach ($user in $main) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level1users.txt -Append
}

$level1 = Get-Content C:\tmp\ad\managers\it\level1.txt
foreach ($manager1 in $level1) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager1 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level2.txt -Append
}
Foreach ($user in $level1) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level2users.txt -Append
}

$level2 = Get-Content C:\tmp\ad\managers\it\level2.txt
foreach ($manager2 in $level2) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager2 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level3.txt -Append
}
Foreach ($user in $level2) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level3users.txt -Append
}

$level3 = Get-Content C:\tmp\ad\managers\it\level3.txt
foreach ($manager3 in $level3) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager3 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level4.txt -Append
}
Foreach ($user in $level3) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level4users.txt -Append
}

$level4 = Get-Content C:\tmp\ad\managers\it\level4.txt
foreach ($manager4 in $level4) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager4 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level5.txt -Append
}
Foreach ($user in $level4) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level5users.txt -Append
}

$level5 = Get-Content C:\tmp\ad\managers\it\level5.txt
foreach ($manager5 in $level5) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager5 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level6.txt -Append
}
Foreach ($user in $level5) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level6users.txt -Append
}

$level6 = Get-Content C:\tmp\ad\managers\it\level6.txt
foreach ($manager6 in $level6) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { Manager -eq $manager6 } -Properties * | select -ExpandProperty DistinguishedName | Out-File C:\tmp\ad\managers\it\level7.txt -Append
}
Foreach ($user in $level6) {
    Get-ADUser -searchbase "OU=Employees,DC=LumosNet,DC=com" -Filter { DistinguishedName -eq $user } -Properties samaccountname | select -ExpandProperty samaccountname | Out-File C:\tmp\ad\managers\it\level7users.txt -Append
}
