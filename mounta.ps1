## Run a script if applicable depending on the SSID of the wireless network connected
## RE - 2011

## Borrowed from:http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

function MountNetworkDrive {
param(
	[string] $Drive,
	[string] $NetworkPath
)
	(New-Object -ComObject "WScript.Network").MapNetworkDrive($Drive, $NetworkPath)
}

function DismountNetworkDrive {
param(
	[string] $Drive
)
	(New-Object -ComObject "WScript.Network").RemoveNetworkDrive($Drive, $true)
}

function Exists-Drive { 
    param([string] $driveletter) 
 
    (New-Object System.IO.DriveInfo($driveletter)).DriveType -ne 'NoRootDirectory'   
} 

function DismountNetworkDriveIfMounted {
	param([string] $driveletter)
	if (Exists-Drive $driveletter)
	{
		DismountNetworkDrive $driveletter
	}
}

$lines = netsh wlan show interfaces 
$filteredLines = $lines | where { $_ -match " : " }
##will need this: http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

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