
#Enhanced Folders and files Fix Invalid Characters
#To replace the spcial characters uncommnet the line Rename-Item -LiteralPath $_.fullname -newname ($newName) -ErrorAction 'Stop' 

Write-Host `n '==================== Special Characters Fix Utility ========================='
function FixSpecialCharacters {
param (
[Parameter(Mandatory = $true)]
$ProcessPath,
[Parameter(Mandatory = $true)]
$FixFolder 
)
$TestPath = test-path $ProcessPath 
$LogTime = Get-Date -Format yyyyMMdd-hhmmss
#$FixFolder=$true
$ReportType= @("Files","Folders")[$FixFolder -eq $true]
$reportfile = $path + '\' + 'DMS-'+$ReportType+'WithInvalidCharacters-' + $LogTime + '.csv'
$AfterProcessingReport = $path + '\' + 'DMS-'+$ReportType+'WithInvalidCharactersAfter-' + $LogTime + '.csv'
$SucessReport = $path + '\' + 'DMS-Fix'+$ReportType+'SucessReport-' + $LogTime + '.csv'
$FailureReport = $path + '\' + 'DMS-Fix'+$ReportType+'FailureReport-' + $LogTime + '.csv'
if ($TestPath) { 
$files=@()
if ($FixFolder ) {
$files = @(Get-ChildItem -Path $path -Directory -Recurse | Where-Object {$_.name -match '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2}|\.$|(?:\.files)$'} `
| Select-Object @{ l = 'Character'; e = { [regex]::Matches($_.name, '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2}|\.$|(?:\.files)$') } } `
, name, Directory, fullName, extension)
}else {
$files = @(Get-ChildItem -Path $path -File -Recurse | Where-Object {$_.name -match '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2}|\.$|(?:\.files)$'} `
| Select-Object @{ l = 'Character'; e = { [regex]::Matches($_.name, '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2}|\.$|(?:\.files)$') } } `
, name, Directory, fullName, extension)
}
if ($files.Count -gt 0) { 
Write-Host "Will Process: " -NoNewline -ForegroundColor Yellow 
write-host $files.Count $ReportType -ForegroundColor Magenta
$files | Export-Csv -Path $reportfile -NoTypeInformation -Encoding UTF8 
$Success = 0;
$Issues = 0;
"FullName`tNewName">>$SucessReport
"Error`tFullName`tNewName">>$FailureReport
$files | ForEach-Object { $newName = (($_.name -replace '[!~#%&*{}|:<>?/|"]', '_') -replace '[.]+', '.' ).TrimStart("[._-]+")
$CurrentFile = $_.fullName 
if (-not ($_.name -eq $newname)) { 
try {
# Rename-Item -LiteralPath $_.fullname -newname ($newName) -ErrorAction 'Stop'
$Success++
Write-Host $Success ": " $_.name -ForegroundColor Cyan -NoNewline
Write-Host ' renamed succussfully to: ' -ForegroundColor Green -NoNewline
Write-Host $newName -ForegroundColor Cyan
"" + $_.fullName + "`t" + $newName >> $SucessReport
}
catch {
$Issues++
Write-Host $Issues $Error[0].Exception.Message -ForegroundColor red
"" + $Error[0].Exception.Message.Trim() + "`t" + $CurrentFile + "`t" + $newName >> $FailureReport
}
 
} 
} 
if ([System.IO.File]::Exists($reportfile )) {
Write-Host `n 'Report Generated successfully' $reportfile -ForegroundColor Green
$files2=@()
if ($FixFolder ) {
$files2 = @(Get-ChildItem -Path $path -Directory -Recurse | Where-Object {$_.name -match '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2,}|\.$|(?:\.files)$'} `
| Select-Object @{ l = 'Character'; e = { [regex]::Matches($_.name, '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2,}|\.$|(?:\.files)$') } } `
, name, Directory, fullName, extension )
}else{
$files2 = @(Get-ChildItem -Path $path -File -Recurse | Where-Object {$_.name -match '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2,}|\.$|(?:\.files)$'} `
| Select-Object @{ l = 'Character'; e = { [regex]::Matches($_.name, '^[\._]|[!#%&*{}\:<>?\/|`"~]|\.{2,}|\.$|(?:\.files)$') } } `
, name, Directory, fullName, extension )
}
if ($files2.Count -gt 0) { 
$files2 | Export-Csv -Path $AfterProcessingReport -NoTypeInformation -Encoding UTF8 
} 
}
}
else {
Write-Host `n 'No files need to be fixed' -ForegroundColor red
 
}
} 
else { 
write-host `n "Invalid path details.... Please run the script again and enter the valid path" -ForegroundColor Red
write-host `n "SCRIPT FINISHED" -fore yellow 
}
} 

# do
# {
Write-Host "`nEnter Folder Path On the computer: " -ForegroundColor Yellow -NoNewline
$path = read-host
Write-Host "`nFolder Path: " -NoNewline -ForegroundColor Cyan
Write-Host $path -ForegroundColor White 
Write-Host "`nWhat do you want to fix:`n1- Folders`n2- Files`n" -ForegroundColor Yellow
$WhatToFix=Read-Host
$FixFolder=@($false,$true)[$WhatToFix -eq 1]
Write-Host "`nStarting To fix"@("Files ...","Folders ...")[$FixFolder] -ForegroundColor Cyan
FixSpecialCharacters $path $FixFolder
# Write-Host "`nDo you want to continue: Y/N " -NoNewline -ForegroundColor Yellow
# $x= Read-Host 
# }
# while ($x.ToLower() -ne "n")
