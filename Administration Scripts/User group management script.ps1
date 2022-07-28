# User group management script

function Search-ADGroup {
    param (
    [Parameter (Mandatory = $true)]
    [string]$groupname
    )
    
    $groupname = "ncorp"
    $grouparray = @()
    $groupinfo = @(Get-AdGroup -Filter "name -like '*$groupname*'" -Properties Description,Canonicalname)
    Write-Host "`n------------------------------------------------`n" -f Gray
    Write-Host "Possible groups by name:" 
    Write-Host "`n------------------------------------------------`n" -f Gray

    $groupinfo

    foreach ($group in $groupinfo){
        $userobj = [PSCustomObject]@{
            Name = $user.name
            Samaccountname = $user.samaccountname
            Description = $user.description
        }
        $UserTable += $userobj

    }


}

$prompt = Read-Host "Enter AD Group name or keyword or (C) to cancel"

do {
Search-ADGroup -groupname $prompt
$prompt = Read-Host "Enter AD Group name or keyword or (C) to cancel"
} while ($prompt -ne "C")

