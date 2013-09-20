# Delete Empty Directories

$starttime=[datetime]::now

# Set the path of where the SVN extraction folders are located

$folders = 'C:\SVN'

# Remove all directories that are empty

Get-ChildItem $folders -recurse | Where {$_.PSIsContainer -and `
@(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |
Remove-Item -Recurse -Verbose

Write-Host ""
Write-Host -foregroundcolor Blue "Script Completed on $(get-date)"
write-host ""
write-host "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
write-host ""