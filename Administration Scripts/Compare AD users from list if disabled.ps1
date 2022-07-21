$list = Get-Content C:\tmp\projects\ad\systemsfull\ebsusers.txt

$cox = New-ConditionalText Cox

$output = @()

foreach ($user in $list) {
    Write-Host "Checking $($user)" -f Green
	$userlist = Get-ADUser -filter {name -like $user -or samaccountname -like $user} -properties name,samaccountname,company,Title,enabled,Description   | Select Name,SamAccountName,company,Title,Enabled,Description  
	

    $isactive = [PSCustomObject]@{
        User               = if ($userlist.name) {$userlist.name} else {"N/A"}
        Username           = $user
        Active             = if ($userlist.enabled) {"Active"} else {"Disabled"}
		Company            = if ($userlist.company) {$userlist.company} else {"N/A"}
		Title              = if ($userlist.Title) {$userlist.Title} else {"N/A"}
		Description        = if ($userlist.Description) {$userlist.Description} else {"N/A"}
    }

    $output += $isactive

    }
$output | Export-Excel -Path C:\tmp\projects\ad\systemsfull\ebsusers_company_Title.csv -AutoSize -AutoFilter -ConditionalText $cox