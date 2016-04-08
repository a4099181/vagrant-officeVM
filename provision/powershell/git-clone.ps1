# file    : git-clone.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * takes a repositores list to clone from a text file
# * uses a git provisioned with chocolatey and accessible in PATH
# * executes git clone for each repository
# * clones the repositories into MyProjects folder in user profile

$projects = Join-Path $env:UserProfile 'MyProjects'
$list     = Join-Path $projects        'git-clone.json'

Get-Content                     -Path $list                          `
   | ConvertFrom-Json                                                `
   | Select-Object             -ExpandProperty repositories          `
   | ForEach-Object                                                  `
{
        Start-Process           -FilePath 'git'                      `
                                -ArgumentList "clone $($_.url)"      `
                                -WorkingDirectory $projects          `
                                -NoNewWindow                         `
                                -PassThru                            `
                                -Wait
}