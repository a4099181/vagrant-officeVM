Function Copy-GitRepositories
{
<#
    .SYNOPSIS
    This function clones git respositories enumerated in configuration file.

    .DESCRIPTION
    This function in details:
    * creates destination folder if it not exists,
    * takes a repositores list to clone from configuration file,
    * skips repositories marked as disabled,
    * clones each repository left,
    * uses a git that should be already provisioned and accessible,
    * clones the repositories into specified destination folder,
    * initializes submodules within repositories.

    .PARAMETER CfgFile
    Configuration file.

    .PARAMETER DestinationFolder
    Destination folder for cloned repositories.

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/docs/Copy-GitRepositories.md

    .LINK
    https://github.com/a4099181/vagrant-officeVM/blob/master/provision/powershell/git-clone.psm1
#>
    Param ( [Parameter(Mandatory=$true)][String] $CfgFile
          , [String] $DestinationFolder = ( Join-Path $env:UserProfile 'MyProjects' ) )

    if ((Test-Path $DestinationFolder)-eq 0)
    {
        New-Item -Path $DestinationFolder -ItemType Directory
    }

    ( Get-Content $CfgFile | ConvertFrom-Json ).repos |
        Where-Object { -Not $_.disabled } |
        ForEach-Object {
            Start-Process -FilePath 'git' `
                          -ArgumentList "clone --recursive $($_.url)" `
                          -WorkingDirectory $DestinationFolder `
                          -NoNewWindow `
                          -PassThru `
                          -Wait
        }
}
