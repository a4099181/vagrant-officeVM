<#
    .SYNOPSIS
    This function connects VPN.

    .DESCRIPTION
    This module:
    * takes a dialup credentials list from a JSON formatted text file
    * establishes VPN connection.

    .PARAMETER CfgFile
    Configuration file.

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : vpn.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Connect-Vpn (
      [Parameter(Mandatory=$true)][String] $CfgFile
    , [Parameter(Mandatory=$true)][String] $KeyFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json
    $cfg.vault |
        Select-Object -expand secret |
        % { Decrypt $_ $KeyFile }

    $cfg.vault |
        ? { $_.type -eq "dialup" } |
        % { rasdial `"$($_.secret.name)`" `"$($_.secret.username)`" `"$($_.secret.password)`" /domain:`"$($_.secret.domain)`"; ` }
}

<#
    .SYNOPSIS
    This function adds VPN connection triggers.

    .DESCRIPTION
    This module:
    * registers VPN application triggers for some executable files:
      - Visual Studio IDE,
      - eTask,
      - mintty terminal emulator,
      - MS Edge,
      - Remote Desktop Client.
    All this thing happens just for more ergonomics.

    .PARAMETER ConnectionName
    VPN connection name.

    .NOTES
    File Name : vpn.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Add-VpnConnectionTriggers(
      [Parameter(Mandatory=$true)][String] $ConnectionName )
{
    $current = Get-VpnConnectionTrigger "$connectionName" |
        Select-Object -ExpandProperty ApplicationID

    Get-ChildItem -Path ${env:ProgramFiles(x86)}, $env:ProgramW6432 , $env:USERPROFILE `
            -Include devenv.exe, eTask.exe, mintty.exe, mstsc.exe `
            -File -Recurse |
        ? { !$current -Or -Not $current.Contains($_.FullName) } |
        % { Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)" -ConnectionName "$connectionName" }

    Get-ChildItem -Path $env:windir\System32 `
            -Include mstsc.exe `
            -File |
        ? { !$current -Or -Not $current.Contains($_.FullName) } |
        % { Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)" -ConnectionName "$connectionName" }

    Get-AppxPackage |
        ? { $_.Name.EndsWith(".MicrosoftEdge") } |
        ? { !$current -Or -Not $current.Contains($_.PackageFamilyName) } |
        % { Add-VpnConnectionTriggerApplication -ApplicationID  "$($_.PackageFamilyName)" -ConnectionName "$connectionName" }
}
