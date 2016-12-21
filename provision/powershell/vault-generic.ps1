# file    : vault-generic.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a generic credentials list from a JSON formatted text file
# * stores credentials into Windows Vault

. "C:\vagrant\Utils\CryptoLib.ps1"

$key = "c:\vagrant\.vagrant\my-private.key"
$json = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json
$json.cfg.vault                                                           `
    | Select-Object -expand secret                                        `
    | ForEach-Object { Decrypt $_ $key }
$pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
$cred = New-Object pscredential("vagrant",  $pass)

$json.cfg                                                                    `
   | Select-Object            -ExpandProperty vault                          `
   | Where-Object         { $_.type -eq "generic" }                          `
   | ForEach-Object                                                          `
{                                                                            `
    Start-Process cmdkey  -Credential $cred                                  `
                          -LoadUserProfile                                   `
                          -NoNewWindow                                       `
                          -Wait                                              `
          "/generic:$($_.secret.server) /user:$($_.secret.username) /pass:$($_.secret.password)"; `
}
