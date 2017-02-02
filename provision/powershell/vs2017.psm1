<#
    .SYNOPSIS
    This function installs Visual Studio 2017 Enterprise with custom workloads and components.

    .DESCRIPTION
    This function:
    * downloads Visual Studio 2017 Enterprise from official website.
    * takes a Visual Studio components list to install from a text file
    * runs the installer with following selected:

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name : install.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
Function Install-VisualStudio2017 (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    if ( -Not $cfg.vs2017.disabled )
    {
        $installerPath = Join-Path $env:LOCALAPPDATA 'Temp\vs_Enterprise.exe'

        if (-Not (Test-Path ($installerPath)))
        {
            $getFrom = 'https://aka.ms/vs/15/release/vs_Enterprise.exe'

            Invoke-WebRequest -Uri $getFrom -OutFile $installerPath
        }

        $components = $cfg.vs2017 |
            select  -ExpandProperty components |
            ? { -Not $_.disabled } |
            % { "--add $($_.id)" }

        start -Wait -FilePath $installerPath -ArgumentList ( "--quiet", "--lang en-US" + $components )
    }
}
<#
    .SYNOPSIS
    This function installs Visual Studio 2017 extensions enumerated in configuration file.

    .DESCRIPTION
    This script:
    * takes a Visual Studio extensions list to install from a text file
    * downloads extension from Visual Studio Gallery
    * executes installer for each downloaded extension

    This script is designed to work with Visual Studio Marketplace.

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name : install.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
Function Install-VisualStudio2017Extensions (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    if ( -Not $cfg.vs2017.disabled )
    {
        $temp      = Join-Path $env:LOCALAPPDATA 'Temp'
        $gallery   = 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/'
        $installer = Get-ChildItem -Path ${env:ProgramFiles(x86)} -Recurse `
                            -Filter "VSIXInstaller.exe" |
                        Select-Object -ExpandProperty FullName -First 1

        $cfg.vs2017.extensions |
            ? { -Not $_.disabled } |
            % {
                $out  = Join-Path         $temp "$($_.publisher).$($_.name).vsix"
                $uri  = "$($gallery)$($_.publisher)/vsextensions/$($_.name)/latest/vspackage"

                Invoke-WebRequest -Uri  $uri `
                                  -OutFile $out
                Start-Process     -FilePath $installer `
                                  -ArgumentList "/quiet", $out `
                                  -NoNewWindow `
                                  -PassThru `
                                  -Wait
        }
    }
}
<#
    .SYNOPSIS
    This function installs Visual Studio related software enumerated in configuration file.

    .DESCRIPTION
    This script:
    * takes a Visual Studio related software list to install from a configruation file
    * installs software from chocolatey's packages.

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name : install.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
Function Install-VisualStudio2017Packages (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    if ( -Not $cfg.vs2017.disabled )
    {
        $cfg.vs2017.chocolatey.packages |
            ? { -Not $_.disabled } |
            % { cinst --limit-output --ignore-checksums --allow-empty-checksums -y $_.id }
    }
}

