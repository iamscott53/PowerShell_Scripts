$List1 = Get-Content C:\tmp\ebs\EBSusers1.txt
$List2 = Get-Content C:\tmp\ebs\EBSusers2.txt

(Compare-Object -ReferenceObject $List1 -DifferenceObject $List2 |
     ForEach-Object {
         $_.SideIndicator = $_.SideIndicator -replace '=>','Not in new file' -replace '<=','Not in merged file'
         $_
     }) | Out-File C:\tmp\ebs\EBSmerged_comparison.txt