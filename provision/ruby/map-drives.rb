# file    : map-drives.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# Visual Studio extensions provisioning
# VS extensions to install can be managed with vs-extensions.txt file.

def provision_drives vm
    vm.provision 'shell', name: 'map-drives.[ rb | ps1 ]', privileged: false,
        powershell_args: '-NonInteractive',
        run: 'up', path: 'provision\powershell\map-drives.ps1'
end

