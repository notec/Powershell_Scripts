#Function Count-Up
#{
#    while($i -lt 9999)
#    {
#        $i++
#    }
# 
#    Write-Host “Count complete - We have counted up to $i”
#}

for(;;) {
 try {
  # invoke the worker script
  C:\Users\j.laramie\Documents\Archive\PS_Scripts\2013-06-11_1700_GoldFile\du.ps1
 }
 catch {
  # do something with $_, wait around...
 }

 # wait for a ten minutes
 Start-Sleep 600
}

#& C:\Users\j.laramie\Documents\Archive\PS_Scripts\2013-06-11_1700_GoldFile\du.ps1