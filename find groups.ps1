Get-ADGroup -filter {name -like "*NAME*"} -properties * | select name,description