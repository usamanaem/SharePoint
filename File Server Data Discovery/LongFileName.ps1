#Get long file names >128 characters and full path >260

$LogTime = Get-Date -Format yyyyMMdd-hhmmss
$path = "Folder Location"
$reportfile=$path +'\'+'LongFileName-'+$LogTime+'.csv'
$reportLongPath=$path +'\'+'Longpath-'+$LogTime+'.csv'
$files =Get-ChildItem -Path $path -Recurse | select FullName, @{Name="FileNameLength"; Expression={($_.Name.Length)}}  | where {$_.FileNameLength -gt 128} |  Sort-Object -Property FileNameLength -Descending
$files | Export-Csv -Path $reportfile -NoTypeInformation -Encoding UTF8
$FilePaths=Get-ChildItem -Path $path -Recurse | select FullName,@{Name="FullNameLength"; Expression={($_.FullName.Length)}}  | where {$_.FullNameLength -gt 260} |  Sort-Object -Property FullNameLength -Descending
$FilePaths | Export-Csv -Path $reportLongPath -NoTypeInformation -Encoding UTF8
