# file    : vpn-triggers.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * registers VPN application triggers for some executable files:
#   - Visual Studio IDE,
#   - eTask,
#   - mintty terminal emulator,
#   - MS Edge,
#   - Remote Desktop Client.
# All this thing happens just for more ergonomics.

$current = Get-VpnConnectionTrigger "Soneta VPN"                                     `
              | Select-Object       -ExpandProperty ApplicationID 

Get-ChildItem -Path ${env:ProgramFiles(x86)}, $env:ProgramW6432                      `
                  , $env:USERPROFILE                                                 `
              -File                                                                  `
              -Recurse                                                               `
              -Include devenv.exe, eTask.exe, mintty.exe, mstsc.exe                  `
   | Where-Object { !$current -Or -Not $current.Contains($_.FullName) }              `
   | ForEach-Object                                                                  `
   {                                                                                 `
       Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)"           `
                                           -ConnectionName "Soneta VPN"              `
   }
 
Get-ChildItem -Path $env:windir\System32                                             `
              -File                                                                  `
              -Include mstsc.exe                                                     `
   | Where-Object { !$current -Or -Not $current.Contains($_.FullName) }              `
   | ForEach-Object                                                                  `
   {                                                                                 `
       Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)"           `
                                           -ConnectionName "Soneta VPN"              `
   }
 
Get-AppxPackage                                                                      `
   | Where-Object   { $_.Name.EndsWith(".MicrosoftEdge") }                           `
   | Where-Object   { !$current -Or -Not $current.Contains($_.PackageFamilyName) }   `
   | ForEach-Object                                                                  `
   {                                                                                 `
       Add-VpnConnectionTriggerApplication -ApplicationID  "$($_.PackageFamilyName)" `
                                           -ConnectionName "Soneta VPN"              `
   }
