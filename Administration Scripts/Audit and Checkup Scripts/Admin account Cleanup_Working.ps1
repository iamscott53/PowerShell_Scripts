# Search all disable user for admin attribute and display it
Get-AdUser -filter {enabled -eq $false} -Properties * | select samaccountname,extensionAttribute11 | Export-Excel -Path C:\tmp\ad\admin\AdminCheckup.csv -AutoSize -AutoFilter


# Search admin accounts and ensure disabled/deleted