$folders = 'C:\'

#Get-ChildItem $folders -Filter * -Recurse | Select-String -pattern analytics
Get-ChildItem $folders -Filter * -Recurse | Select-String -pattern ff0000