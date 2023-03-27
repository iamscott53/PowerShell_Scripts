function Get-ADGroupManagementInfo {

    $output = @()
    $ADAccountImport = Get-ADUser -filter * -properties title, company, emailaddress
    $ADGroupImport = Get-ADGroup -filter * -properties members, description, grouptype, groupscope, distinguishedName

    foreach ($group in $ADGroupImport) {

        $titles = @("VPs","SrDir", "Dir", "SrMgr", "Mgr", "Supervisor")

        Write-Host "`nProcessing: $($group)" -f Green

        $groupMemberData = $group.members
        
        if ($groupMemberData.Count -gt 0) {

            $memberArray = @()
            $lumosUserArray = @()
            $segraUserArray = @()

            $ErrorActionPreference = "SilentlyContinue"

            foreach ($member in $groupMemberData) {
                Write-Host "Sub-processing: $($member)" -f Cyan
                $userData = $null
                $userData = $ADAccountImport | Where-Object { $_.distinguishedname -eq $member } 
                $memberArray += $userData

                if ($userData.company -like "*Lumos*" -or $userData.emailaddress -like "*lumosfiber*" -or $userData.distinguishedName -like "*OU=Lumos Employees*" -or $userData.distinguishedName -like "*OU=Resico Contractors*") {
                    $lumosUserArray += $userData
                }
                else {
                    $segraUserArray += $userData
                }
            }

            $rankingUsers = @()

            
            #Catch Vice Presidents 
            $VPs = $memberArray | Where-Object { $_.title -like "*VP,*" -or $_.title -like "* VP *" -or $_.title -like "*Vice Pres*" -or $_.title -like "*VP.*" } | Select-Object EmailAddress
            $SrDir = $memberArray | Where-Object { $_.title -like "*Senior Dir*" -or $_.title -like "*Sr. Dir*" -or $_.title -like "*Sr Dir*" } | Select-Object EmailAddress
            $Dir = $memberArray | Where-Object { ($_.title -like "*Director*" -and $_.title -notlike "*Sr.*" -and $_.title -notlike "*Senior*") } | Select-Object EmailAddress
            $SrMgr = $memberArray | Where-Object { $_.title -like "*Senior*Manager*" -or $_.title -like "*Sr.*Manager*" -or $_.title -like "*Sr*Mgr*" -or $_.title -like "*Senior*Mgr*" } | Select-Object EmailAddress
            $Mgr = $memberArray | Where-Object { ($_.title -like "*Manager*" -or $_.title -like "*Mgr *") -and $_.title -notlike "*Sr*" -and $_.title -notlike "*Senior*" } | Select-Object EmailAddress
            $Supervisor = $memberArray | Where-Object { $_.title -like "*Supervisor*" }

            $titles | ForEach-Object {
                
                if (Test-Path variable:$_) {
                    $var = Get-Variable -Name $_

                    if ($var.Value) {
                        Write-Host "Found $($var.Name)"

                        $result = foreach ($obj in $var.Value) { "$($obj.EmailAddress)" }
                        $result
                        New-Variable -Name "$($_)2" -Value $result
                    }
                }
            }

            Write-Host "`nSegra user count: $($segraUserArray.Count)"
            Write-Host "Lumos user count: $($lumosUserArray.Count)"

            if ($segraUserArray.Count -eq 0 -and $lumosUserArray.Count -gt 0) {
                $ContainsOnlyLumosUsers = $true
                Write-Host "Contains only Lumos users!" -f Magenta
            }
            else {
                $ContainsOnlyLumosUsers = $false
            }
            
            if ($VPs2 -or $SrDir2 -or $Dir2 -or $SrMgr2 -or $Mgr2) {
                $groupOutputData = [PSCustomObject]@{
                    Name                   = $group
                    Description            = $group.description
                    MemberCount            = $groupMemberData.Count
                    Combined               = "$VPs2; $SrDir2; $Dir2; $SrMgr2; $Mgr2"
                    VPs                    = $VPs2 -join ";
                    SeniorDir              = $SrDir2 -join "; "
                    Director               = $Dir2 -join "; "
                    SrMgr                  = $SrMgr2 -join "; "
                    Manager                = $Mgr2 -join "; "
                    Supervisor             = $Supervisor2 -join "; "
                    GroupType              = $group.grouptype
                    GroupScope             = $group.groupscope
                    GroupCategory          = $group.groupcategory
                    OU                     = $group.distinguishedName -replace '.+?,OU=(.+?),(?:OU|DC)=.+', '$1'
                    ContainsOnlyLumosUsers = $ContainsOnlyLumosUsers
                    LumosUsers             = $lumosUserArray.Count
                    SegraUsers             = $segraUserArray.Count
                }

                Write-Host "`n"
                $groupOutputData 
                $output += $groupOutputData
            }

        }

        $titles | ForEach-Object {
            Remove-Variable -Name $_ -Force

            $tempVar = "$($_)2"
            if (Test-Path variable:$tempVar) {
                Remove-Variable -Name  -Force
            }
        
            [System.GC]::Collect()
        }
    }

    return $output

}
}