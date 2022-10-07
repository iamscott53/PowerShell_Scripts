$nscom = Get-Content "C:\tmp\nscomemails.txt" 
| ForEach-Object {
  $mail = $_
  $user = Get-ADUser -LDAPFilter "(mail=$mail)"
  if ( $user ) {
    $sAMAccountName = $user.sAMAccountName
  }
  else {
    $sAMAccountName = $null
  }
  [PSCustomObject] @{
    "mail" = $mail
    "sAMAccountName" = $sAMAccountName
  }
} | Export-Csv "C:\tmp\users-output.csv" -NoTypeInformation