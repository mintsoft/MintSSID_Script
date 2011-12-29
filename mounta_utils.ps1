## Supporting functions to mount and check for drives etc
## Based on:http://social.technet.microsoft.com/Forums/en-CA/winserverpowershell/thread/4ac53d11-40ed-4c40-aab3-451ad502667e

## For example: MountNetworkDrive "M":" "\\myServer\share"
function MountNetworkDrive 
{
	param([string] $Drive, [string] $NetworkPath)
	
	(New-Object -ComObject "WScript.Network").MapNetworkDrive($Drive, $NetworkPath)
}

## For example: DismountNetworkDrive "M:"
##   this will error if the drive isn't mounted
function DismountNetworkDrive 
{
	param([string] $Drive)
	
	(New-Object -ComObject "WScript.Network").RemoveNetworkDrive($Drive, $true)
}

## For example: Exists-Drive "M:"
##   Returns true if the drive exists
function Exists-Drive 
{ 
    param([string] $driveletter) 
 
    (New-Object System.IO.DriveInfo($driveletter)).DriveType -ne 'NoRootDirectory'   
} 

## For example: DismountNetworkDriveIfMounted "M:"
#   Will dismount a network drive if it is mounted, else do nothing
function DismountNetworkDriveIfMounted 
{
	param([string] $driveletter)
	
	if (Exists-Drive $driveletter)
	{
		DismountNetworkDrive $driveletter
	}
}
