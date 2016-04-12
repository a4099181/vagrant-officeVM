# file    : map-drives.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a drives mappings list to from a JSON formatted text file
# * stores credentials into Windows Vault
# * creates a new drive for each entry
#
# Some weird resolution made and notation (at least for me) gives
# a successful credentials storage usable at later time.
# There is no need to enter username/password to reconnect mapped drives.

$temp = Join-Path $env:LOCALAPPDATA 'Temp'
$list = Join-Path $temp 'map-drives.json'
$pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
$cred = New-Object pscredential("vagrant",  $pass)


Get-Content                   -Path $list                                 `
   | ConvertFrom-Json                                                     `
   | Select-Object            -ExpandProperty mappings                    `
   | ForEach-Object                                                       `
{                                                                         `
    Start-Process cmdkey      -Credential $cred                           `
                              -LoadUserProfile                            `
                              -NoNewWindow                                `
                              -Wait `
           "/add:$($_.server) /user:$($_.username) /pass:$($_.password)"; `
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
