# file    : defender.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * registers Windows Defender exclusion for some executable files:
#   - MSBuild,
#   - Visual Studio IDE,
#   - SQL command line tool,
#   - SQL LocalDB DBMS,
#   - SQL Server DBMS,
# * registers Windows Defender exclusion for some folders or files:
#   - custom Visual Studio Projects folder,
#   - nuget cache in user profile,
#   - babun folder,
#   - swap file,
# * registers Windows Defender exclusion for some file extensions:
#   config, ldf, mdf, ttf, txt, log
# All these things happens just for improving VM performance.

Get-ChildItem -Path ${env:ProgramFiles(x86)}, $env:ProgramW6432           `
              -File                                                       `
              -Recurse                                                    `
              -Include msbuild.exe, devenv.exe    , sqlcmd.exe            `
                                  , sqllocaldb.exe, sqlservr.exe          `
                                  , sqlwriter.exe                         `
   | ForEach-Object                                                       `
   {                                                                      `
        Add-MpPreference -ExclusionProcess $_.FullName                    `
   }

Get-ChildItem -Path $env:USERPROFILE                                      `
              -Directory                                                  `
              -Recurse                                                    `
              -Include MyProjects, .nuget, .babun                         `
   | ForEach-Object                                                       `
   {                                                                      `
        Add-MpPreference -ExclusionPath $_.FullName                       `
   }


Add-MpPreference -ExclusionPath C:\pagefile.sys                           `
                 -ExclusionExtension config, cs , ldf, lnk, mdf, ttf, txt `
                                           , xml, log
