# file    : vault-dialup.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a dialup credentials list from a JSON formatted text file
# * stores dialup credentials using dialupass utility.

. "C:\vagrant\Utils\CryptoLib.ps1"

$key = "c:\vagrant\.vagrant\my-private.key"
$json = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json
$json.cfg.vault                                                           `
    | Select-Object -expand secret                                        `
    | ForEach-Object { Decrypt $_ $key }

$json.cfg                                                                                            `
   | Select-Object            -ExpandProperty vault                                                  `
   | Where-Object             { $_.type -eq "dialup" }                                               `
   | ForEach-Object                                                                                  `
{                                                                                                    `
        dialupass /setpass    `"$($_.secret.name)`" `"$($_.secret.username)`" `"$($_.secret.password)`" `"$($_.secret.domain)`"; `
}
