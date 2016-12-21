# file    : vpn.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# Connecting to VPN. It requires a valid credentials to be stored in cfg.json.

def connect_vpn vm
    vm.provision 'shell', name: 'vpn.rb', privileged: false, run: 'up',
        powershell_args: '-NoProfile -ExecutionPolicy ByPass',
        path: 'provision\powershell\vpn-connect.ps1'
end

