# file    : map-drives.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a drives mappings list to from a JSON formatted text file
# * creates a new drive for each entry

. "C:\vagrant\Utils\CryptoLib.ps1"

$pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
$cred = New-Object pscredential("vagrant",  $pass)

$key = "c:\vagrant\.vagrant\my-private.key"
$json = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json
$json.cfg.drives                                                          `
    | Select-Object -expand secret                                        `
    | ForEach-Object { Decrypt $_ $key }

$json.cfg                                                                 `
   | Select-Object            -ExpandProperty drives                      `
   | ForEach-Object                                                       `
{                                                                         `
    Start-Process powershell  -Credential $cred                           `
                              -LoadUserProfile                            `
                              -NoNewWindow                                `
                              -Wait                                       `
@"
        New-SmbMapping        -LocalPath       $($_.local)               ``
                              -RemotePath      $($_.secret.remote)       ``
                              -Persistent      `$True                    ``
                              -SaveCredentials
"@                                                                        `
}
