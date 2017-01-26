<#
    .SYNOPSIS
    This function adds generic Windows Credentials enumerated in configuration file.

    .DESCRIPTION
    This module:
    * takes a generic credentials list from a JSON formatted text file
    * stores credentials into Windows Vault

    .PARAMETER CfgFile
    Configuration file.

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : vault.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Add-GenericWindowsCredentials (
      [Parameter(Mandatory=$true)][String] $CfgFile
    , [Parameter(Mandatory=$true)][String] $KeyFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json
    $cfg.vault |
        Select-Object -expand secret |
        % { Decrypt $_ $KeyFile }
    $pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
    $cred = New-Object pscredential("vagrant",  $pass)

    $cfg.vault |
        ? { $_.type -eq "generic" } |
        % {
            Start-Process cmdkey  -Credential $cred `
                                  -LoadUserProfile `
                                  -NoNewWindow `
                                  -Wait `
                "/generic:$($_.secret.server) /user:$($_.secret.username) /pass:$($_.secret.password)"; `
        }
}
<#
    .SYNOPSIS
    This function adds domain Windows Credentials enumerated in configuration file.

    .DESCRIPTION
    This module:
    * takes a domain credentials list from a JSON formatted text file
    * stores credentials into Windows Vault

    .PARAMETER CfgFile
    Configuration file.

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : vault.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Add-WindowsCredentials (
      [Parameter(Mandatory=$true)][String] $CfgFile
    , [Parameter(Mandatory=$true)][String] $KeyFile )
{
    $cfg = Get-Content $CfgFile | ConvertFrom-Json
    $cfg.vault |
        Select-Object -expand secret |
        % { Decrypt $_ $KeyFile }
    $pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
    $cred = New-Object pscredential("vagrant",  $pass)

    $cfg.vault |
        ? { -Not $_.type -Or $_.type -eq "domain" } |
        % {
            Start-Process cmdkey  -Credential $cred `
                                  -LoadUserProfile `
                                  -NoNewWindow `
                                  -Wait `
                "/add:$($_.secret.server) /user:$($_.secret.username) /pass:$($_.secret.password)"; `
        }
}
