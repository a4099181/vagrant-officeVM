# file    : install.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * downloads Visual Studio 2017 Enterprise from official website.
# * runs the installer with following selected:
#   @ workloads:
#     - .NET desktop development
#   @ components:
#     - .NET Framework 4 - 4.6 development tools
#     - SQL Server Native Client
#     - SQL Server Command Line Utilities
#     - SQL Server Express 2016 LocalDB

$installerPath = Join-Path $env:LOCALAPPDATA 'Temp\vs_Enterprise.exe'

if (-Not (Test-Path ($installerPath)))
{
    $getFrom = 'https://aka.ms/vs/15/release/vs_Enterprise.exe'

    Invoke-WebRequest -Uri $getFrom -OutFile $installerPath
}

Start-Process -Wait -FilePath $installerPath -ArgumentList "--quiet", "--lang en-US" , `
    " --add Microsoft.VisualStudio.Workload.ManagedDesktop"                          , `
    " --add Microsoft.Net.ComponentGroup.TargetingPacks.Common"                      , `
    " --add Microsoft.VisualStudio.Component.SQL.NCLI"                               , `
    " --add Microsoft.VisualStudio.Component.SQL.CMDUtils"                           , `
    " --add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime"
