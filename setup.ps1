# file    : setup.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script executes local Windows machine provisioning.

$wdir = ( Get-Location )
$args = "-ExecutionPolicy ByPass", "-NoLogo", "-NonInteractive",
        "-NoProfile", "-Sta", "-Command cd '$wdir';"

Start-Process powershell -Wait -Args ($args+"Merge-ConfigurationFiles config\common.json, config\user.json | Out-File -Encoding utf8 cfg.json")
Start-Process powershell -Wait -Args ($args+"setup\elevated.ps1") -Verb runAs
Start-Process powershell -Wait -Args ($args+"setup\non-privileged.ps1")
