# file    : elevated.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

$CfgFile="cfg.json"
$Path = Join-Path $ENV:UserProfile 'bin'

Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
Install-CommonPackages $CfgFile
robocopy sysroot c:\ /S /NDL /NFL
Install-VisualStudio2017 $CfgFile
Install-VisualStudio2017Packages $CfgFile
Add-SystemPath(@($Path))
Add-WindowsDefenderExclusions
Add-VpnConnectionTriggers "Soneta VPN"
