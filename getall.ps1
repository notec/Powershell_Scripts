# get paths, cleanup, extraction | Remove Directories, files and data files [getall.ps1]

# Set-ExecutionPolicy

Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Set literal path for output file: ..\paths.txt
# Can take up to eight hours to complete

$starttime=[datetime]::now

svn ls -R https://tddp-svn-01/svn/dev/ | where-object {$_.EndsWith("trunk/")} > C:\SVN\paths.txt

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "Get Paths From SVN Completed on $(get-date)"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Remove unnessisary path inclusions before extraction begins

$path = 'C:\SVN\paths.txt'

Select-String -pattern deprecated, tags, branches, Avaya_DD_Demo, FacebookUIDemo, HandsetDemo, SkinnableDemo, WalletDemo, RechargeCafeDemo, CannedDemo, Architecture, CentennialUS, GWCelBR, MetroPCSUS, OrangeFR, StraightTalkUS, TargetTMobileUS, TMobileUK $path -notmatch | % {$_.Line} | set-content -Verbose C:\SVN\newpaths.txt

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "Clean Paths Of Un-wanted Projects Completed on $(get-date)"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Extract code from SVN

$paths = get-content C:\SVN\newpaths.txt

foreach ($path in $paths)
    
    {
        svn export https://tddp-svn-01/svn/dev/$path C:\SVN\$path
    }

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "Subversion Extraction Complete on $(get-date)"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Set the path of where the SVN extraction folders are located

$folders = 'C:\SVN'

# Copy path text files out to a new directory (if it doesn't exist, create it) for safe keeping

$destinationFolder = 'C:\tmp'

if (!(Test-Path -path $destinationFolder)) {New-Item $destinationFolder -Type Directory}
Get-ChildItem -path $folders -filter *.txt | Copy-Item -Destination $destinationFolder

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "STEP 1: Copy Text Files To /tmp"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Remove directories

Get-ChildItem $folders -r -Include *Audio, *Test, *Simulator, *Documents, *Documentation, *Database, *Temporary, *TestHarness, *Sim | Remove-Item -Recurse -Force -Verbose

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "STEP 2: Data Directories Deleted"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Remove Misc Files

Get-ChildItem $folders -r -Include *version, *notice, *mailcap, *license, *simversion, *package-list, *cacerts, *testdata, *readme, *repository, *antrun, *ant, *changelog, *root, *todo, *Copy.jar, *depcomp, *missing, *install.sh, *install-sh, *configuration, *compile, *cleancount, *compat, *copyright, *control, *testFiles, *Test_Load | Remove-Item -Recurse -Force -Verbose

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "STEP 3: Remove Misc Files"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Remove useless data files

Get-ChildItem $folders -r -Include *.classpath, *.cfg, *.css, *.doc, *.dtd, *.gif, *.html, *.keystore, *.lst, *.map, *.msg, *.name, *.out, *.pdf, *.png, *.prefs, *.project, *.providers, *.rsa, *.service, *.sf, *.simdata, *.tests, *.txt, *.wsdl, *.sql, *.properties, *.bak, *.cmd, *.container, *.datatypefactory, *.db, *.dev, *.documentbuilderfactory, *.docx, *.domimplementationsourcelist, *.driver, *.handlers, *.htm, *.ico, *.inf, *.ini, *.jpg, *.jsdtscope, *.ldif, *.lg, *.mex, *.mymetadata, *.mystrutsdata, *.name, *.prod, *.res, *.resx, *.saxparserfactory, *.schemafactory, *.schemas, *.sqlt, *.thmx, *.tld, *.wldata, *.wsdd, *.xls, *.wav, *.afm, *.api_description, *.dat, *.cat, *.exsd, *.index, *.xmi, *.log, *.mappings, *.mod, *.cmap, *.aliases, *.list, *.rpt, *.rdl, *.vxml, *.xml, *.zip, *.war, *.bat, *.json, *.in, *.twig, *.csv, *.msi, *.vox, *.vsd, *.pptx, *.sdx, *.swf, *.graphviz, *.speechplugin, *.exe, *.xlsx, *.settings, *.manager, *.project, *.dtsx, *.rwz, *.cls, *.jmx, *.m4, *.htc, *.rptdesign, *.ttf, *.woff, *.eot, *.sub, *.guess, *.install, *.vbs, *.pm, *.xsd, *.prompt, *.MF, *.cer, *.pem, *.der, *.sh, *.cs, *.xsx, *.options, *.csp, *.config, *.gram-builtin, *.xsl, *.tpl, *.yml, *.foot, *.pbxindex, *.myumldata, *.tgz, *.gitignore, *.cvsignore, *.stamp, *.svg, *.pdb, *.copy, *.flow, *.msc, *.m, *.def, *.vcproj, *.rptconfig, *.am, *.vsscc, *.1, *.2, *.3, *.ocx, *.cab, *.vox_prenotification, *.vox_postnotification*, *.policy, *.cmake, *.xlf, *org.* | Remove-Item -Recurse -Force -Verbose

Write-Host -ForegroundColor DarkCyan ""
Write-Host -ForegroundColor DarkCyan "STEP 4: Data Files Deleted"
write-host ""
write-host -ForegroundColor DarkCyan "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host -ForegroundColor DarkCyan ""

# Find and Remove all directories that are empty

Write-Host ""
Write-Host -ForegroundColor Red "About To Delete Empty Directories!"
Write-Host ""

Get-ChildItem $folders -recurse | Where {$_.PSIsContainer -and `
@(Get-ChildItem -Lit $_.Fullname -r | Where {!$_.PSIsContainer}).Length -eq 0} |
Remove-Item -Recurse -Verbose

Write-Host ""
Write-Host "Subversion Extraction and Cleanup Complete on $(get-date)"
write-host ""
write-host "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
Write-Host ""