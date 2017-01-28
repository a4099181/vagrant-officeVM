# file    : Encrypt-Config.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * encrypts secret regions of the single configuration file for this project
# * it overwrites the encrypted version of the config file
#
# Usage            : powershell /C   Encrypt-Config.ps1
#    (inside shell): powershell /C ./Encrypt-Config.ps1

. ".\CryptoLib.ps1"

$cfg = "..\config\user.json"
$key = "..\.vagrant\my-private.key"
$jsn = Get-Content $cfg | ConvertFrom-Json

$arr = @( $jsn.drives, $jsn.vault )

foreach ($a in $arr)
{
    $a | Select-Object -expand secret | ForEach-Object { Encrypt $_ $key }
}

ConvertTo-Json $jsn -Depth 4 | Out-File -Encoding utf8 $cfg
