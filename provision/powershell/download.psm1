Function Expand-DownloadedArchive
{
<#
    .SYNOPSIS
    This function downloads zip files enumerated in configuration file.

    .DESCRIPTION
    This function in details:
    * takes a zip file list to download from configuration file,
    * downloads each zip file,
    * extracts each file to location specified in configuration file.

    .PARAMETER CfgFile
    Configuration file.

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Expand-DownloadedArchive.md

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/download.psm1
#>
    Param (
        [Parameter(Mandatory=$true)][String] $CfgFile )

    $zipFile = Join-Path $env:LOCALAPPDATA "Temp\tmp.zip"
    $cfg     = Get-Content $CfgFile | ConvertFrom-Json

    if ( $cfg.download -And $cfg.download.zip )
    {
        $cfg.download.zip |
            ForEach-Object {
                Invoke-WebRequest $_.url -UseBasicParsing -OutFile $zipFile
                Expand-Archive -LiteralPath $zipFile -DestinationPath $_.destination -Force
            }
    }
}
