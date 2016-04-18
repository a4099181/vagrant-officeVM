# file    : vsix.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a Visual Studio extensions list to install from a text file
# * locates Visual Studio Extension installer
# * identifies current URI of the current version for each extension
# * downloads extension from Visual Studio Gallery
# * executes installer for each downloaded extension

$temp      = Join-Path $env:LOCALAPPDATA 'Temp'
$list      = Join-Path $temp 'vs-extensions.txt'
$gallery   = 'https://visualstudiogallery.msdn.microsoft.com/'
$installer = Get-ChildItem       -Path ${env:ProgramFiles(x86)}             `
                                 -Filter "VSIXInstaller.exe"                `
                                 -Recurse                                   `
           | Select-Object       -ExpandProperty FullName                   `
                                 -First 1

Get-Content                      -Path $list                                `
    | Select-String              -Pattern '^#', '^\s*$'                     `
                                 -NotMatch                                  `
    | Where-Object               { $_.Line.Split('|')[1].Trim() -eq 'yes' } `
    | ForEach-Object             {

        $id  =                   $_.Line.Split('|')[0].Trim()
        $uri = Invoke-WebRequest -UseBasicParsing                           `
                                 -Uri $gallery$id                           `
             | Select-Object     -ExpandProperty Links                      `
             | Where-Object      { $_.href.EndsWith("vsix") }               `
             | Select-Object     -ExpandProperty href
        $out = Join-Path         $temp "$($id).vsix"

        Invoke-WebRequest        -Uri "$($gallery)$($uri)"                  `
                                 -OutFile $out
        Start-Process            -FilePath $installer                       `
                                 -ArgumentList "/quiet", "/admin", $out     `
                                 -NoNewWindow                               `
                                 -PassThru                                  `
                                 -Wait
}
