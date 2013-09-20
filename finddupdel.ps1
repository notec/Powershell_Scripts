function Get-SHA512([System.IO.FileInfo] $file = $(throw 'Usage: Get-MD5 [System.IO.FileInfo]'))
{
  	$stream = $null;
  	$cryptoServiceProvider = [System.Security.Cryptography.SHA512CryptoServiceProvider];
  	$hashAlgorithm = new-object $cryptoServiceProvider
  	$stream = $file.OpenRead();
  	$hashByteArray = $hashAlgorithm.ComputeHash($stream);
  	$stream.Close();

  	## Close file stream if exceptions are thrown

  	trap
  	{
   		if ($stream -ne $null)
    		{
			$stream.Close();
		}
  		break;
	}	

 	foreach ($byte in $hashByteArray) { if ($byte -lt 16) {$result += �0{0:X}� -f $byte } else { $result += �{0:X}� -f $byte }}
	return [string]$result;
}

$starttime=[datetime]::now

write-host "FindDupdel.ps1 - find and optionally delete duplicates. FindDupdel.ps1 -help or FindDupdel.ps1 -h for usage options."

$matches = 0     	# initialize number of matches for summary
$filesdeleted = 0 	# number of files deleted
$bytesrec = 0 		# Number of bytes recovered


if ($args -eq "-help" -or $args -eq "-h") # check for help request, if found display usage options...
{
	""
	"Usage:"
	"       PS>.\FindDupdel.ps1 <directory/file #1> <directory/file #2> ... <directory/file #N> [-delete] [-noprompt] [-recurse] [-help]"
	"Options:"
	"       -recurse recurses through all subdirectories of any specified directories."
	"       -delete prompts to delete duplicates (but not originals.)"
	"       -delete with -noprompt deletes duplicates without prompts (but again not originals.)"
	"	-hidden checks hidden files, default is to ignore hidden files."
	"	-help displays this usage option data, and ignores all other arguments."
	""
	"Examples:"
	"          PS>.\FindDupdel.ps1 c:\data d:\finance -recurse"
	"          PS>.\FindDupdel.ps1 d: -recurse -delete -noprompt"
	"          PS>.\FindDupdel.ps1 c:\users\alice\pictures\ -recurse -delete"
 	exit
}


# build list of files, by running dir on $args minus elements that have FindDupdel.ps1 switches, recursively if specified.

$files=(dir ($args | ?{$_ -ne "-delete" -and $_ -ne "-noprompt" -and $_ -ne "-recurse" -and $_ -ne "-hidden"}) -recurse:$([bool]($args -eq "-recurse")) -force:$([bool]($args -eq "-hidden")) |?{$_.psiscontainer -eq $false})


if ($files.count -lt 2)  # if the number of files is less than 2, then exit
{
	"Need at least two files to check.`a"
	exit
}

for ($i=0;$i -ne $files.count; $i++)  # Cycle thru all files
{
	if ($files[$i] -eq $null) {continue}  # file was already identified as a duplicate if $null, so do next file

	$filecheck = $files[$i]  	      # backup file object
	$files[$i] = $null	              # erase file object from object database, so it is not matched against itself

	for ($c=$i+1;$c -lt $files.count; $c++)  # cycle through all files again
	{
		if ($files[$c] -eq $null) {continue}  # $null = file was already checked/matched.
	
		if ($filecheck.fullname -eq $files[$c].fullname) {$files[$c]=$null;continue} # If referencing the same file, skip
	
		if ($filecheck.length -eq $files[$c].length)  # if files match size then check SHA512's
		{
			if ($filecheck.SHA512 -eq $null)         # if SHA512 is not already computed, compute it
			{ 
				$SHA512 = (get-SHA512 $filecheck.fullname)
				$filecheck = $filecheck | %{add-member -inputobject $_ -name SHA512 -membertype noteproperty -value $SHA512 -passthru}			
			}
			if ($files[$c].SHA512 -eq $null)         # resulting in no file being SHA512'ed twice.
			{ 
				$SHA512 = (get-SHA512 $files[$c].fullname)
				$files[$c] = $files[$c] | %{add-member -inputobject $_ -name SHA512 -membertype noteproperty -value $SHA512 -passthru}				
			}
			
			if ($filecheck.SHA512 -eq $files[$c].SHA512) # Size already matched, if SHA512 matches, then it's a duplicate.
			{
				
				write-host "Size and SHA512 match: " -fore red -nonewline
				write-host "`"$($filecheck.fullname)`" and `"$($files[$c].fullname)`""

				$matches += 1			# Number of matches ++
				
				if ($args -eq "-delete")        # check if user specified to delete the duplicate
				{
					if ($args -eq "-noprompt")  # if -delete select, and -noprompt selected
					{
						del $files[$c].fullname  # then delete the file without prompting
						write-host "Deleted duplicate: " -f red -nonewline
						write-host "`"$($files[$c].fullname).`""
					}
					else
					{
						del $files[$c].fullname -confirm # otherwise prompt for confirmation to delete
					}
					if ((get-item -ea 0 $files[$c].fullname) -eq $null) # check if file was deleted.
					{
						$filesdeleted += 1		# update records
						$bytesrec += $files[$c].length
					}

				}
	
				$files[$c] = $null		# erase file object so it is not checked/matched again.
			}
		}	
	}	# And loop to next inner loop file
}		# And loop to next file in outer/original loop
write-host ""
write-host "Number of Files checked: $($files.count)."	# Display useful info; files checked and matches found.
write-host "Number of duplicates found: $matches."
Write-host "Number of duplicates deleted: $filesdeleted." # Display number of duplicate files deleted and bytes recovered.
write-host "$bytesrec bytes recovered."	
write-host ""
write-host "Time to run: $(([datetime]::now)-$starttime|select hours, minutes, seconds, milliseconds)"
write-host ""