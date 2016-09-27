# file    : vscode.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a Visual Studio Code extensions list to install from a text file
# * executes VS Code to install extensions

$temp      = Join-Path $env:LOCALAPPDATA 'Temp'
$list      = Join-Path $temp 'vscode-extensions.txt'

Get-Content                      -Path $list                                `
    | Select-String              -Pattern '^#', '^\s*$'                     `
                                 -NotMatch                                  `
    | Where-Object               { $_.Line.Split('|')[1].Trim() -eq 'yes' } `
    | ForEach-Object             {

        $id  =                   $_.Line.Split('|')[0].Trim()
        code --install-extension $id
}
