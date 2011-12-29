#########################################################################################
## Run a script if applicable depending on the SSID of the wireless network connected
## RE - 2011
#########################################################################################

## Load the supporting utils
. "./mounta_utils.ps1"

$lines = netsh wlan show interfaces 
$filteredLines = $lines | where { $_ -match " : " }
## Will need this: 
##   http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

$parsed = $filteredLines -split " : "

$objArray = @{}
$key = ""; $val = ""; $x=1
foreach ($line in $parsed)
{
	if($x -eq 1)
	{
		$key = $line.Trim()
		$x=2
	}
	else
	{
		$val = $line.Trim()
		$x=1
		
		$objArray[$key] = $val
	}
}

## If connected to a wireless network, then run the named script

if($objArray['State'] -eq "connected")
{
	# Run the "before" script
	& "Scripts-defaults\pre.ps1";
	
	#check if file exists and run it
	$scriptName = '.\Scripts-custom\'+$objArray['SSID']+'.ps1';
	if(Test-Path $scriptName)
	{
		& $scriptName;
	}
	
	# Run the "after" script
	& "Scripts-defaults\post.ps1";
	
}