# file    : vsix-marketplace.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a Visual Studio extensions list to install from a text file
# * downloads extension from Visual Studio Gallery
# * executes installer for each downloaded extension
#
# This script is designed to work with Visual Studio Marketplace.

$temp      = Join-Path $env:LOCALAPPDATA 'Temp'
$cfg       = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json
$gallery   = 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/'
$installer = Get-ChildItem       -Path ${env:ProgramFiles(x86)}             `
                                 -Filter "VSIXInstaller.exe"                `
                                 -Recurse                                   `
           | Select-Object       -ExpandProperty FullName                   `
                                 -First 1

$cfg.vs2017.extensions |
    ? { -Not $_.disabled } |
    % {
        $out  = Join-Path         $temp "$($_.publisher).$($_.name).vsix"
        $uri  = "$($gallery)$($_.publisher)/vsextensions/$($_.name)/latest/vspackage"

        Invoke-WebRequest        -Uri  $uri                                 `
                                 -OutFile $out
        Start-Process            -FilePath $installer                       `
                                 -ArgumentList "/quiet", $out               `
                                 -NoNewWindow                               `
                                 -PassThru                                  `
                                 -Wait
}
