<#
    .SYNOPSIS
    This module clones git respositories enumerated in configuration file.

    .DESCRIPTION
    This module:
    * takes a repositores list to clone from a text file
    * takes care of MyProjects folder existance
    * uses a git provisioned with chocolatey and accessible in PATH
    * executes git clone for each repository
    * clones the repositories into MyProjects folder in user profile

    .PARAMETER CfgFile
    Configuration file.

    .NOTES
    File Name : git-clone.psm1
    Author    : seb! <sebi@sebi.one.pl>
    License   : MIT
#>
function Copy-GitRepositories (
      [Parameter(Mandatory=$true)][String] $CfgFile )
{
    $projects = Join-Path $env:UserProfile 'MyProjects'
    $cfg = Get-Content $CfgFile | ConvertFrom-Json

    if ((Test-Path $projects)-eq 0)
    {
        New-Item -Path $projects -ItemType Directory
    }

    $cfg.repos |
        % {
            Start-Process -FilePath 'git' `
                          -ArgumentList "clone $($_.url)" `
                          -WorkingDirectory $projects `
                          -NoNewWindow `
                          -PassThru `
                          -Wait
        }
}
