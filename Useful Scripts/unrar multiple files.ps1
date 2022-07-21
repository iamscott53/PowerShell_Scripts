# Folder with RAR files
$filerar = "C:\tmp\projects\zip\downloads"

# Folder for extracted files
$filedone = "C:\tmp\projects\zip\completed"

$Zips = Get-ChildItem -filter "*.rar" -path $filerar -Recurse
$Destination = "C:\tmp\projects\zip\completed"
$WinRar = "C:\Program Files\WinRAR\rar.exe"

foreach ($zip in $Zips)
{
&$Winrar x -y $zip.FullName $Destination
}