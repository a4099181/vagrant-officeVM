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
$list      = Join-Path $temp 'vs-marketplace.txt'
$gallery   = 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/'
$installer = Get-ChildItem       -Path ${env:ProgramFiles(x86)}             `
                                 -Filter "VSIXInstaller.exe"                `
                                 -Recurse                                   `
           | Select-Object       -ExpandProperty FullName                   `
                                 -First 1

Get-Content                      -Path $list                                `
    | Select-String              -Pattern '^#', '^\s*$'                     `
                                 -NotMatch                                  `
    | Where-Object               { $_.Line.Split('|')[2].Trim() -eq 'yes' } `
    | ForEach-Object             {

        $psh  =                   $_.Line.Split('|')[0].Trim()
        $nme  =                   $_.Line.Split('|')[1].Trim()
        $out  = Join-Path         $temp "$($psh).$($nme).vsix"
        $uri  = "$($gallery)$($psh)/vsextensions/$($nme)/latest/vspackage"

        Invoke-WebRequest        -Uri  $uri                                 `
                                 -OutFile $out
        Start-Process            -FilePath $installer                       `
                                 -ArgumentList "/quiet", $out               `
                                 -NoNewWindow                               `
                                 -PassThru                                  `
                                 -Wait
}
