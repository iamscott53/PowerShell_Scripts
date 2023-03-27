$grabDate = ((Get-Date).AddDays(-7)).Date

Get-ADUser -filter {enabled -eq $false -and whenChanged -ge $grabDate} -properties * | where { ($_.memberof | measure).count -gt 1} | select samaccountname,name,description,whenChanged | Out-File C:\tmp\ADAccounts.txt
