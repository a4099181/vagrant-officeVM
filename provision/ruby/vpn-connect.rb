# file    : vpn.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# Connecting to VPN. It requires a valid batch file to be deployed.
# This file contains sensitive data. That's why it should be deployed using
# sysroot-protected support.

def connect_vpn vm
    vm.provision 'shell', name: 'vpn.rb', privileged: false, run: 'up',
        inline: 'c:\Users\vagrant\AppData\Local\Temp\vpn-connect.cmd'
end

