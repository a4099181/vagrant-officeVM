# file    : git-clone.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a repositores list to clone from a text file
# * takes care of MyProjects folder existance
# * uses a git provisioned with chocolatey and accessible in PATH
# * executes git clone for each repository
# * clones the repositories into MyProjects folder in user profile

$projects = Join-Path $env:UserProfile 'MyProjects'
$cfg = Get-Content C:\vagrant\cfg.json | ConvertFrom-Json

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
