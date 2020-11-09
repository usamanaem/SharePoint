#Get Hidden files

Get-ChildItem -Path "e:\shared folders" -Recurse -Hidden |select Name,FullName|Export-Csv "C:\SharedFolders\HiddenFiles.csv" -NoTypeInformation
