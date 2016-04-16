# file    : map-drives.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a drives mappings list to from a JSON formatted text file
# * creates a new drive for each entry

$temp = Join-Path $env:LOCALAPPDATA 'Temp'
$list = Join-Path $temp 'map-drives.json'
$pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
$cred = New-Object pscredential("vagrant",  $pass)


Get-Content                   -Path $list                                 `
   | ConvertFrom-Json                                                     `
   | Select-Object            -ExpandProperty drives                      `
   | ForEach-Object                                                       `
{                                                                         `
    Start-Process powershell  -Credential $cred                           `
                              -LoadUserProfile                            `
                              -NoNewWindow                                `
                              -Wait                                       `
@"
        New-SmbMapping        -LocalPath       $($_.local)               ``
                              -RemotePath      $($_.remote)              ``
                              -Persistent      `$True                    ``
                              -SaveCredentials
"@                                                                        `
}
