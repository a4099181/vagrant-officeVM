# file    : sysroot.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# My custom solution to provision VM with arbitrary uploaded predefined files.
def provision_sysroot vm
    vm.provision "shell", name: "sysroot.rb", run: "up",
        inline: "robocopy c:\\vagrant\\sysroot c:\\ /S /NDL /NFL"
end
