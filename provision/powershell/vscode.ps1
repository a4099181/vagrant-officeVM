# file    : vscode.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a Visual Studio Code extensions list to install from a text file
# * executes VS Code to install extensions

$json = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json

$json.cfg.vscode                                        `
    | Select-Object  -ExpandProperty extensions         `
    | Where-Object   { -Not $_.disabled }               `
    | ForEach-Object { code --install-extension $_.name }
