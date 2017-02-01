<#
    .SYNOPSIS
    This function installs packages enumerated in configuration files.

    .DESCRIPTION
    This function in details:
    * takes a list of packages from configuration file,
    * installs each package with chocolatey package manager.

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name: chocolatey.psm1
    Author:    seb! <sebi@sebi.one.pl>
    License:   MIT
#>
function Install-CommonPackages (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    $cfg.chocolatey.packages |
        ? { -Not $_.disabled } |
        % { cinst --allow-empty-checksums -y $_.id }
}
