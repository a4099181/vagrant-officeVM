# file    : babun.ps1
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# This script:
# * downloads babun from official website.
# * unzip downloaded archive within user profile environment.
# * locates babun installation batch file.
# * makes a very silent installer for vagrant environment:
#   - every 'pause' command is removed,
#   - babun is not started just after installation.
#   It is required for provisioning babun well.
# * runs the modified babun installation batch file.
# * registers mintty.exe as VPN connection trigger.

if (-Not (Test-Path (Join-Path $env:USERPROFILE ".babun")))
{
    $getFrom = 'http://projects.reficio.org/babun/download'
    $putTo   = Join-Path $env:LOCALAPPDATA 'Temp/babun'

    Start-BitsTransfer -Source $getFrom -Destination $putTo'.zip'
    unzip -o $putTo'.zip' -d $putTo

    $setup  = Get-ChildItem -Path $putTo -Recurse -Filter install.bat   `
            | Select-Object -First 1

    $silent = Join-Path $setup.Directory "silent-$($setup.Name)"

    Get-Content        $setup.FullName                                  `
       | Select-String -Pattern 'babun.bat', 'pause'                    `
                       -NotMatch                                        `
       | Out-File      -Encoding ascii -Force $silent

    Start-Process $setup.FullName -NoNewWindow -PassThru

    Get-VpnConnection                                                   `
       | ForEach-Object                                                 `
       {                                                                `
            Add-VpnConnectionTriggerApplication                         `
                  -ConnectionName $_.Name                               `
                  -ApplicationID                                        `
                     "$($env:USERPROFILE)\.babun\cygwin\bin\mintty.exe" `
       }
}

