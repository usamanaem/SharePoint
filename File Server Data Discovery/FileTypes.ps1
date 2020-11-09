#Generate report for file types 

Write-Host `n 'Enter Folder Path On the computer: ' -ForegroundColor Yellow -NoNewline
$path = read-host
# file name to log file extension and number of files by the type
$filetypelist = $path+"\Summary Files types for " + (Split-Path -Path $path -Leaf) + ".csv"
# file name to log file list by extension
$filelist = $path+ "\Detailed Files types for " + (Split-Path -Path $path -Leaf) + ".csv"
#Search the given path and group the results by Extension
$DirInfo = Get-ChildItem -Path $path -Recurse | where { -not $_.PSIsContainer } | group Extension | sort count -desc
#Write the results in to log files
"Extension`tCount" | Out-File -FilePath $filetypelist
foreach($f in $DirInfo)
{
$f.Name + "`t" + $f.Count
$f.Name + "`t" + $f.Count | Out-File -FilePath $filetypelist -Append
"File Report on Extension`: " + $($f.Name) + " (Count`: " + $f.Count + ")" | Out-File -FilePath $FileList -Append
$f.Group.FullName | Out-File -FilePath $FileList -Append
"`n`r`n`r" | Out-File -FilePath $filelist -Append
}
