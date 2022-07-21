$firstname = Read-Host "Enter first name";
$lastname = Read-Host "Enter last name";
[datetime]$Date = Read-Host "Enter start date (mm/dd/yy)";
$first_initial = $firstname[0];
$username = "$($lastname)$($first_initial)"
$email = "Enable-remotemailbox -identity $username -remoteroutingaddress `"$($firstname).$($lastname)@lumosnetworks.mail.onmicrosoft.com`"`n`n"

## $passw1 = Invoke-RestMethod https://random-word-api.herokuapp.com/word?number=1
## $passw2 = Invoke-RestMethod https://random-word-api.herokuapp.com/word?number=1
## $passw2 = $passw2.substring(0,1).toupper()+$passw2.substring(1).tolower()
## $passw3 = Invoke-RestMethod https://random-word-api.herokuapp.com/word?number=1
## $passw4 = Invoke-RestMethod https://random-word-api.herokuapp.com/word?number=1
## $passwlist = Invoke-RestMethod https://random-word-api.herokuapp.com/word?number=10
## $passnum = Get-Random -Maximum 9
$message =
"Account $username has been created for this request.`nNetwork Credentials`nUsername: $username`nPassword: $passw1$passw2$passnum`nEmail: $($firstname).$($lastname)@segra.com`n`n"
 
Write-Host "`n`nAccount Details for $($firstname) $($lastname):`n" -f Cyan
$message
 
Write-Host "EMS Command:" -f Cyan
$email
 
Write-Host "Contractor expiration date:" -f Cyan -nonewline
$Date.adddays(+90)
 

Write-Host "`n`nBCC List:" -f Cyan
Write-Host "Salamat, JP; McQuillen, Justin A.; Wingo, Eric; Marsh, AJ; Beard, Jonathan; Simmers, Timothy; Jason Meyer; Wesley Hall; Lee, Richard; Kiefer, Alex K"


Write-Host "`n`nWant to add/change a word to password? Here's a list:" -f Cyan
Write-Host $passwlist
