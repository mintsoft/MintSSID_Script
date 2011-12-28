## Run a script if applicable depending on the SSID of the wireless network connected
## RE - 2011

## Borrowed from:http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

function MountNetworkDrive {
param(
	[string] $Drive,
	[string] $NetworkPath
)
	Write-Host "-> MountNetworkDrive"
	$objNet = New-Object -ComObject "WScript.Network"
	$objNet.MapNetworkDrive(($Drive), $NetworkPath)
	Start-Sleep -Milliseconds 500	
	Write-Host (Get-PSDrive) # Do not remove, is't workaround for Join-Path
	Write-Host "<- MountNetworkDrive"
}
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
function DismountNetworkDrive {
param(
	[string] $Drive
)
	Write-Host "-> DismountNetworkDrive"
	$objNet = New-Object -ComObject "WScript.Network"
	Write-Host "Removing $Drive ..."
	$objNet.RemoveNetworkDrive($Drive, $true)
	Write-Host "<- DismountNetworkDrive"
}



$lines = netsh wlan show interfaces 
$filteredLines = $lines | where { $_ -match " : " }
##$filteredLines = $lines | where { $_ -match "State|SSID" } | where { $_ -notMatch "BSSID" }
##will need this: http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

$parsed = $filteredLines -split " : "

$objArray = @{}
$key = ""
$val = ""
$x=1
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

#$objArray

if($objArray['State'] -eq "connected")
{
	#check if file exists and run it
	$scriptName = '.\Scripts\'+$objArray['SSID']+'.ps1';
	if(Test-Path $scriptName)
	{
		& $scriptName;
	}
}