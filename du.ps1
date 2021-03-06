# Set the path of where the SVN extraction folders are located
# and find out how much disk space is used

$folders = 'C:\SVN'

gci $folders | %{$f=$_; gci -r $_.FullName| measure-object -property length -sum | select  @{Name="Name"; Expression={$f}} , @{Name="Sum (MB)"; Expression={  "{0:N3}" -f ($_.sum / 1MB) }}, Sum } | sort Sum -desc | format-table -Property Name,"Sum (MB)", Sum -autosize