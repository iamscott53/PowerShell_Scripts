function Find-Group {
    param (
    [Parameter (Mandatory = $true)]
    [string]$groupname
    )

    Write-Host "`n------------------------------------------------`n" -f Gray
    Write-Host "Possible groups by name:" 
    Get-AdGroup -Filter "name -like '*$groupname*'" -Properties Description,Canonicalname | select-object Name,Description
    Write-Host "`n------------------------------------------------`n" -f Gray

    Write-Host "Possible groups by Description:" 
    Get-AdGroup -Filter "Description -like '*$groupname*'" -Properties Description,Canonicalname | select-object Name,Description
    Write-Host "`n------------------------------------------------`n" -f Gray
}

$prompt = Read-Host "Enter AD Group name or keyword or (C) to cancel"

do {
Find-Group -groupname $prompt
$prompt = Read-Host "Enter AD Group name or keyword or (C) to cancel"
} while ($prompt -ne "C")