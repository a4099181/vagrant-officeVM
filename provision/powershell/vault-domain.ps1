# file    : vault-domain.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a domain credentials list from a JSON formatted text file
# * stores credentials into Windows Vault

$temp = Join-Path $env:LOCALAPPDATA 'Temp'
$list = Join-Path $temp 'vault.json'
$pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
$cred = New-Object pscredential("vagrant",  $pass)

Get-Content               -Path $list                                        `
   | ConvertFrom-Json                                                        `
   | Select-Object        -ExpandProperty credentials                        `
   | Where-Object         { -Not $_.type -Or $_.type -eq "domain" }          `
   | ForEach-Object                                                          `
{                                                                            `
    Start-Process cmdkey  -Credential $cred                                  `
                          -LoadUserProfile                                   `
                          -NoNewWindow                                       `
                          -Wait                                              `
              "/add:$($_.server) /user:$($_.username) /pass:$($_.password)"; `
}
