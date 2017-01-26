<#
    .SYNOPSIS
    This function add Windows defender exclusions.

    .DESCRIPTION
    This module:
    * registers Windows Defender exclusion for some executable files:
      - MSBuild,
      - Visual Studio IDE,
      - SQL command line tool,
      - SQL LocalDB DBMS,
      - SQL Server DBMS,
    * registers Windows Defender exclusion for some folders or files:
      - custom Visual Studio Projects folder,
      - nuget cache in user profile,
      - babun folder,
      - swap file,
    * registers Windows Defender exclusion for some file extensions:
      config, ldf, mdf, ttf, txt, log
    All these things happens just for improving VM performance.

    .NOTES
    File Name : defender.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Add-WindowsDefenderExclusions
{
    Get-ChildItem -Path ${env:ProgramFiles(x86)}, $env:ProgramW6432 `
            -Include msbuild.exe, devenv.exe, sqlcmd.exe, sqllocaldb.exe,
                sqlservr.exe, sqlwriter.exe `
            -File -Recurse |
        % { Add-MpPreference -ExclusionProcess $_.FullName }

    Get-ChildItem -Path $env:USERPROFILE `
            -Include MyProjects, .nuget, .babun `
            -Directory -Recurse |
        % { Add-MpPreference -ExclusionPath $_.FullName }

    Add-MpPreference -ExclusionPath C:\pagefile.sys `
            -ExclusionExtension config, cs , ldf, lnk, mdf, ttf, txt, xml, log
}
