#Retrieve long path files and folders

$path = "[Path]"
$p="\\?\"+$path
$OoriginalPath="Site URL"
Get-ChildItem -LiteralPath $p -Recurse | select Name,@{Name="FileFullName"; Expression={($_.FullName.replace("\\?\",""))}} ,@{Name="FullNameLength"; Expression={($_.FullName.replace("\\?\","").Length)}}  | where {$_.FullNameLength -gt 256 }  |  Sort-Object -Property FullNameLength -Descending | Export-Csv -NoTypeInformation "$path\LongPathresult.csv" 

Get-ChildItem  $p -Recurse | select Name,@{Name="FileFullName"; Expression={($_.FullName.replace("\\?\",""))}} ,@{Name="FullNameLength"; Expression={($_.FullName.replace("\\?\","").Length+$OoriginalPath.Length)}}  |  where {$_.FullNameLength -gt 256 } |Sort-Object -Property FullNameLength -Descending | Export-Csv -NoTypeInformation "$path\LongPathresult2.csv"
