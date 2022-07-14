
 function CI-DisableUsersConnect {
    Write-Host "`nPlease enter Lumosnet credentials: " -f yellow
    $credential = Get-Credential

    Write-Host "`nConnecting to EXO ... "
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline -Credential $credential
    Write-Host "`nConnected." -f green

    Write-Host "`nConnecting to Azure Online ... "
    if (Connect-AzureAD -Credential $credential) {
        Write-Host "`nConnected." -f green
    } else {
        Write-Host "`nConnection error. Not connected." -f red 
    }

    Write-Host "`nConnecting to MSOL ... "
    Connect-MsolService -Credential $credential
    Write-Host "`nConnected." -f green

}


function CI-DisableUsersExecute {
    ###CONNECTED###
    $azureObject = $null
    $onPremObject = $null
    $msoToggle = $null
    $msolUserInfo = $null
    $group = $null
    $date = (Get-Date).ToString('MM/dd/yy')

    $name = Read-Host "Enter Name"

    $user = Get-ADUser $name -properties * 
    $groups = Get-AzureADUserMembership -Objectid $user.UserPrincipalName | ? {$_.DirSyncEnabled -ne $true -and $_.ObjectType -ne "Role"}

    if ($groups -eq $null) {
        "No EXO Groups detected."
    } else {

        $exoGroupProps = $groups.ObjectID | % {Get-EXORecipient -Identity $_ | Select displayname,recipienttype,recipienttypedetails}

        $onPremObject = [pscustomobject]@{
                        UserName = $user.SamAccountName
                        DisplayName = $user.displayname
                        Enabled = $user.Enabled
                        UserDN = $user.DistinguishedName
                        }

        Write-Host "`n`nAD User information:" -f DarkCyan
        $onPremObject | Select-Object UserName,DisplayName,Enabled,Description,UserDN

         Write-Host "`n`nEXO User information:`n" -f DarkCyan
         $exoGroupProps | select displayname,recipienttypedetails

        $pause = Read-Host "`n`nEnter any key to continue deprovisioning or Ctrl+C to cancel" 



        $exoGroupProps | Sort-Object -property recipienttypedetails | % {
            if ($_.recipienttypedetails -eq "GroupMailbox" ) {
            Write-Host "`n$($_.displayname) is EXO-Groupmailbox: Using Remove-UnifiedGroupLinks " -f red
            Write-Host "`nRemoving $($user.UserPrincipalName) from group $($_.displayname) ...`n"
            $Error.Clear()
                try { Remove-UnifiedGroupLinks -Identity $_.displayname -LinkType Members -Links $user.UserPrincipalName -confirm:$false -ErrorAction Stop }
                catch [System.Management.Automation.RemoteException] {
                    if ($_.CategoryInfo.Reason -eq "GroupOwnersCannotBeRemovedException" -or ($_.CategoryInfo.Reason -eq "RecipientTaskException" -and $_.Exception -match "Only Members who are not owners")) 
                        { Write-Host "`nERROR: User object ""$($user.Name)"" is owner of the group and cannot be removed. Try to remove ownership link.`n" -ForegroundColor Cyan} 
                    }
                if ($Error.CategoryInfo.Reason -eq "GroupOwnersCannotBeRemovedException") {
                    $user.UserPrincipalName
                    $_.displayname
                     try { Remove-UnifiedGroupLinks -Identity $_.displayname -LinkType Owners -Links $user.UserPrincipalName -confirm:$true }
                     catch [System.Management.Automation.RemoteException] { "`nStill failed.`n"}

                }

                
            } 
            elseif ($_.recipienttypedetails -eq "MailUniversalSecurityGroup" ) {
            Write-Host "`n$($_.displayname) is Azure-MailUniversalSecurityGroup: Using Remove-DistributionGroupMember" -f cyan
            Write-Host "`nRemoving $($user.UserPrincipalName) from group $($_.displayname) ...`n"
            Remove-DistributionGroupMember -Identity $_.displayname -Member $user.samaccountname -BypassSecurityGroupManagerCheck -confirm:$false
            }
            elseif ($_.recipienttypedetails -eq "MailUniversalDistributionGroup" ) {
            Write-Host "`n$($_.displayname) is EXO-MailUniversalDistributionGroup: Using Remove-DistributionGroupMember" -f green
                Write-Host "`nRemoving $($user.UserPrincipalName) from group $($_.displayname) ...`n"
                Remove-DistributionGroupMember -Identity $_.displayname -Member $user.samaccountname -BypassSecurityGroupManagerCheck -confirm:$false
            }
        }
    }


    $UserName = $user.SamAccountName

    try {
      Set-ADUser -Identity $user.SamAccountName -Description "Separation on $date" -Enabled $false
      Write-Host "`n`n$UserName description set." -f Green
      Write-Host "`n$UserName disabled." -f Green
      } catch {
        Write-Host "ERROR in SET USER" -f Red
      }

      try {

      $user.Memberof | % {Write-Host "Removing user $($user.UserPrincipalName) from group $_";Get-ADGroup $_} | Remove-ADGroupMember -Member $user.Samaccountname -Confirm:$false
        Write-Host "`n$UserName groups removed.`n" -f Green
      } catch {
        Write-Host "ERROR in REMOVE GROUPS" -f Red
      }

      Write-Host "Final AD properties: "
      Invoke-Command -ScriptBlock {Get-ADUser $user.SamAccountName -properties * | fl name,description,enabled,memberof}
}




