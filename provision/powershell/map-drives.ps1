# file    : map-drives.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a drives mappings list to from a JSON formatted text file
# * creates a new drive for each entry

$temp = Join-Path $env:LOCALAPPDATA 'Temp'
$list = Join-Path $temp 'map-drives.json'

Get-Content                      -Path $list                          `
   | ConvertFrom-Json                                                 `
   | Select-Object               -ExpandProperty mappings             `
   | ForEach-Object                                                   `
{
        New-SmbMapping           -LocalPath  $_.local                 `
                                 -RemotePath $_.remote                `
                                 -UserName   $_.username              `
                                 -Password   $_.password              `
                                 -Persistent $true
}
