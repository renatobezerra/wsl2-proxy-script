Write-Output "########### WSL2 Proxy Management ##########`n"

$distro = "Ubuntu-20.04" # For check your distro name, using wsl -l -v

Write-Output "Checking if you have upper privilegies ..."

# check if you are in administration mode, if not, ask for authorization
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

Write-Output "Checking if you are upper privilegies done!"

Write-Output "Getting IP from WSL2 Instance ..."
# get wsl intern ip
$wsl_host = $(wsl -d $distro -- ip -o -4 -json addr list eth0 ` | ConvertFrom-Json ` | %{ $_.addr_info.local } ` | ?{ $_ });

Write-Output "WSL2 IP is $wsl_host"

# here you specify the ports for the proxy
$ports = @(1337, 1338, 1339, 27017, 80, 8989, 8083, 27018);

# reset all interfaces
Write-Output "Reset actual proxies ..."
Invoke-Expression "netsh interface portproxy reset";
Write-Output "Reset actual proxies done!"

Write-Output "Creating new proxies ...`n`n"
for ( $i = 0; $i -lt $ports.length; $i++ ) {
	$port = $ports[$i];
	Write-Output "Adding proxy for port $port ..."
	Invoke-Expression "netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$port connectport=$port connectaddress=$wsl_host";
	Write-Output "Adding proxy for port $port done!"
}
Write-Output "Creating new proxies done!"

Write-Output "`n-------- List of new proxies ---------"
Invoke-Expression "netsh interface portproxy show v4tov4";
Write-Output "`n--------------------------------------"

# For starting docker without password, is need to add distro user into sudoers
Write-Output "`n`nStarting docker ..."
$(wsl -d $distro sudo service docker start);
Write-Output "`n`nStarting docker done!"

Write-Output "`n`n\o/\o/\o/\o/\o/\o/  THE END  \o/\o/\o/\o/\o/\o/!"