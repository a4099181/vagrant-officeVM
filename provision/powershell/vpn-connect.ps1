# file    : vpn-connect.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a dialup credentials list from a JSON formatted text file
# * establishes VPN connection.

. "C:\vagrant\Utils\CryptoLib.ps1"

$key = "c:\vagrant\.vagrant\my-private.key"
$cfg = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json
$cfg.vault |
    Select-Object -expand secret |
    % { Decrypt $_ $key }

$cfg.vault                                                                                           `
   | Where-Object             { $_.type -eq "dialup" }                                               `
   | ForEach-Object                                                                                  `
{                                                                                                    `
        rasdial `"$($_.secret.name)`" `"$($_.secret.username)`" `"$($_.secret.password)`" /domain:`"$($_.secret.domain)`"; `
}
