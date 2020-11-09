#Remove $ letter from folders Name

Get-ChildItem '[Path]' | rename-item -newname {[string]($_.name).replace("$","")}
