<#
    .SYNOPSIS
    This function installs Visual Studio Code Extensions enumerated in configuration file.

    .DESCRIPTION
    This script:
    * takes a Visual Studio Code extensions list to install from a text file
    * executes VS Code to install extensions

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name : vscode.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
Function Install-VisualStudioCodeExtensions (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    $cfg.vscode.extensions |
        ? { -Not $_.disabled } |
        % { code --install-extension $_.name }
}
