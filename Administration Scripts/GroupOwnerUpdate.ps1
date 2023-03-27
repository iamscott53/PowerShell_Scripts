$Username = "robertsr" # Replace with actual username
$GroupsFile = "C:\tmp\groups.txt" # Replace with actual path to text file

# Get the user object
$User = Get-ADUser -Identity $Username

# Read the groups from the text file
$Groups = Get-Content $GroupsFile

# Loop through each group and update the "managedBy" attribute
foreach ($Group in $Groups) {
  Set-ADGroup -Identity $Group -ManagedBy $User.DistinguishedName
  Write-Output "Group $Group updated"
}