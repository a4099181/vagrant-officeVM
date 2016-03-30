# file    : sysroot-protected.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# My custom solution to provision VM with encrypted private data.
def provision_sysroot_protected vm
    vm.provision 'shell', name: 'sysroot-protected.[ rb | ps1 ]', run: 'up',
        powershell_args: '-ExecutionPolicy ByPass -NonInteractive',
        privileged: true, path: 'provision\powershell\sysroot-protected.ps1'
end
