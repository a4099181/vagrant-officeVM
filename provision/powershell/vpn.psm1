Function Connect-Vpn
{
<#
    .SYNOPSIS
    This function connects VPN.

    .DESCRIPTION
    This function in details:
    * takes a dialup credentials list from configuration file,
    * establishes VPN connection,
    * supports encrypted secret data,
    * uses rasdial tool to establish VPN connection.

    .PARAMETER CfgFile
    Configuration file.

    .PARAMETER KeyFile
    Encryption key file. If you don't have it, please see New-EncryptionKey.

    .PARAMETER ConnectionName
    VPN connection name to connect.

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Connect-Vpn.md
    
    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/New-EncryptionKey.md

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Protect-Config.md

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/vpn.psm1
#>
    Param ( [Parameter(Mandatory=$true)][String] $CfgFile
          , [Parameter(Mandatory=$true)][String] $KeyFile
          , [Parameter(Mandatory=$true)][String] $ConnectionName )

    $cfg = Get-Content $CfgFile | ConvertFrom-Json
    $cfg.vault |
        Select-Object -expand secret |
        Decrypt $KeyFile

    $cfg.vault |
        Where-Object   { $_.type -eq "dialup" } |
        Where-Object   { $_.secret.name -eq $ConnectionName } |
        ForEach-Object { rasdial `"$($_.secret.name)`" `"$($_.secret.username)`" `"$($_.secret.password)`" /domain:`"$($_.secret.domain)`"; ` }
}

Function Add-VpnConnectionTriggers
{
<#
    .SYNOPSIS
    This function adds VPN connection triggers.

    .DESCRIPTION
    This function in details registers VPN application triggers for specified
    * executables,
    * universal apps.

    The primary aim is more ergonomics.

    .PARAMETER ConnectionName
    VPN connection name.

    .PARAMETER ExecutablePaths
    Paths where specified executable should be search for.

    .PARAMETER Executables
    Executable to register as VPN connection triggers.

    .PARAMETER UniversalApps
    Universal Apps to register as VPN connection triggers.

    Please note, that universal app are searched using .EndsWith(<param-value>) function.

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Add-VpnConnectionTriggers.md
    
    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/vpn.psm1
#>
    Param ( [Parameter(Mandatory=$true)][String] $ConnectionName
          , [String[]] $ExecutablePaths=( ${env:ProgramFiles(x86)}, $env:ProgramW6432 , $env:USERPROFILE, "$env:windir\System32" )
          , [String[]] $Executables=( 'devenv.exe', 'eTask.exe', 'mintty.exe', 'mstsc.exe' )
          , [String[]] $UniversalApps=( '.MicrosoftEdge' ) )

    $current = Get-VpnConnectionTrigger "$connectionName" |
        Select-Object -ExpandProperty ApplicationID

    Get-ChildItem -Path $ExecutablePaths -Include $Executables -File -Recurse |
        Where-Object   { !$current -Or -Not $current.Contains($_.FullName) } |
        ForEach-Object { Add-VpnConnectionTriggerApplication -ApplicationID "$($_.FullName)" -ConnectionName "$connectionName" }

    Get-AppxPackage |
        Where-Object   {$name=$_.Name}{ @( $UniversalApps | Where-Object { $name.EndsWith($_) } ).Count -gt 0 } |
        Where-Object   { !$current -Or -Not $current.Contains($_.PackageFamilyName) } |
        ForEach-Object { Add-VpnConnectionTriggerApplication -ApplicationID  "$($_.PackageFamilyName)" -ConnectionName "$connectionName" }
}
