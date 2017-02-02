<#
    .SYNOPSIS
    This module creates new network drive mappings.

    .DESCRIPTION
    This module:
    * takes a drives mappings list to from a JSON formatted configuration file
    * creates a new drive for each entry

    .PARAMETER CfgFile
    Configuration file

    .PARAMETER KeyFile
    Encryption key file.

    .NOTES
    File Name : map-drives.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
Function Add-DriveMappings (
      [Parameter(Mandatory=$true)][String] $CfgFile
    , [Parameter(Mandatory=$true)][String] $KeyFile )
{
    $pass = ConvertTo-SecureString -AsPlainText -Force "vagrant"
    $cred = New-Object pscredential("vagrant",  $pass)

    $cfg = Get-Content $CfgFile | ConvertFrom-Json
    $cfg.drives |
        Select-Object -expand secret |
        % { Decrypt $_ $KeyFile }

    $cfg.drives |
    % {
        Start-Process powershell  -Credential $cred `
                                  -LoadUserProfile `
                                  -NoNewWindow `
                                  -Wait `
@"
            New-SmbMapping        -LocalPath       $($_.local) ``
                                  -RemotePath      $($_.secret.remote) ``
                                  -Persistent `$True ``
                                  -SaveCredentials
"@
    }
}

