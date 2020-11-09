#Get Big file Sizes ordered desc


Write-Host `n 'Enter Folder Path On the computer: ' -ForegroundColor Yellow -NoNewline
$path = read-host
$LogTime = Get-Date -Format yyyyMMdd-hhmmss
$reportfile=$path +'\'+'FileSizes-'+$LogTime+'.csv'

$files=Get-ChildItem -Path $path -Recurse
write-host "Total" $files.Count "Files" -ForegroundColor Green
$files | select Name,FullName,Length,@{N="SizeKB"; E={"{0:N2}" -f ($_.length/1KB)}},@{N="SizeMB"; E={"{0:N2}" -f ($_.length/1MB)}},@{N="SizeGB"; E={"{0:N2}" -f ($_.length/1GB)}} | Sort-Object length -Descending  | export-csv -NoTypeInformation -Path $reportfile
