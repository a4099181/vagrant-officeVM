# file    : vscode.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a Visual Studio Code extensions list to install from a text file
# * executes VS Code to install extensions

$cfg = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json

$cfg.vscode.extensions |
    ? { -Not $_.disabled } |
    % { code --install-extension $_.name }
