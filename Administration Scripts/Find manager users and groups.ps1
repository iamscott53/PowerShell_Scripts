﻿#List manager's groups!

$username = Read-Host "Enter the username"

# Replace "UserName" with the actual username of the user
$user = Get-ADUser -Identity $username

# Search for groups where the user is the manager
$groups = Get-ADGroup -Filter {managedBy -eq $user.DistinguishedName}

# Print the names of the groups
Write-Host "`nGroups:`n " -ForegroundColor Green
$groups | ForEach-Object {Write-Output $_.Name}

#List contractor account!

$manager = $user

# Search for users in the "Vendor Accounts" OU with the specified manager
$users = Get-ADUser -SearchBase "OU=Vendor Accounts,DC=LumosNet,DC=com" -Filter {Manager -eq $manager.DistinguishedName}

# Print the names of the users
Write-Host "`nUsers:`n" -ForegroundColor Green
$users | ForEach-Object {Write-Output $_.Name}

