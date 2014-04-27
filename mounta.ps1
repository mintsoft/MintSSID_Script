#########################################################################################
## Run a script if applicable depending on the SSID of the wireless network connected
## RE - 2011
#########################################################################################

## Load the supporting utils
. "./mounta_utils.ps1";

$wlan_info = @{};
netsh wlan show interfaces | where { $_ -match " : " } | foreach {
	$split_line = $_.Trim() -split " : ";
	$wlan_info[$split_line[0].Trim()] = $split_line[1].Trim();
}

## If connected to a wireless network, then run the named script
if($wlan_info['State'] -eq "connected")
{
	# Run the "before" script
	& "Scripts-defaults\pre.ps1";
	
	
	
	#check if file exists and run it
	$scriptName = '.\Scripts-custom\'+$wlan_info['SSID']+'.ps1';
	if(Test-Path $scriptName)
	{
		& $scriptName;
	}
	
	# Run the "after" script
	& "Scripts-defaults\post.ps1";
	
}