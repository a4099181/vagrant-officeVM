# file    : vpn-triggers.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * registers VPN application triggers for some executable files:
#   - Visual Studio IDE,
#   - eTask,
# All this thing happens just for more ergonomics.

$current = Get-VpnConnectionTrigger "Soneta VPN"                            `
              | Select-Object       -ExpandProperty ApplicationID 

Get-ChildItem -Path ${env:ProgramFiles(x86)}, $env:ProgramW6432             `
                  , $env:USERPROFILE                                        `
              -File                                                         `
              -Recurse                                                      `
              -Include devenv.exe, eTask.exe, mintty.exe                    `
   | Where-Object { !$current -Or -Not $current.Contains($_.FullName) }     `
   | ForEach-Object                                                         `
   {                                                                        `
       Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)"  `
                                           -ConnectionName "Soneta VPN"     `
   }
 
