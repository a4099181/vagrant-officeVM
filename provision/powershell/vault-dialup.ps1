# file    : vault-dialup.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a dialup credentials list from a JSON formatted text file
# * stores dialup credentials using dialupass utility.

$temp = Join-Path $env:LOCALAPPDATA 'Temp'
$list = Join-Path $temp 'vault.json'

Get-Content                   -Path $list                                                            `
   | ConvertFrom-Json                                                                                `
   | Select-Object            -ExpandProperty credentials                                            `
   | Where-Object             { $_.type -eq "dialup" }                                               `
   | ForEach-Object                                                                                  `
{                                                                                                    `
        dialupass /setpass    `"$($_.name)`" `"$($_.username)`" `"$($_.password)`" `"$($_.domain)`"; `
}
