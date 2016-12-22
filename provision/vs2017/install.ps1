# file    : install.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * downloads Visual Studio 2017 Enterprise from official website.
# * takes a Visual Studio components list to install from a text file
# * runs the installer with following selected:

$installerPath = Join-Path $env:LOCALAPPDATA 'Temp\vs_Enterprise.exe'

if (-Not (Test-Path ($installerPath)))
{
    $getFrom = 'https://aka.ms/vs/15/release/vs_Enterprise.exe'

    Invoke-WebRequest -Uri $getFrom -OutFile $installerPath
}

$json = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json

$components = $json.cfg.vs2017                                        `
    | Select-Object  -ExpandProperty components         `
    | Where-Object   { -Not $_.disabled }               `
    | % { "--add $($_.id)" }

Start-Process -Wait -FilePath $installerPath -ArgumentList ( "--quiet", "--lang en-US" + $components )
