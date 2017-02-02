# file    : powershell.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# My custom solution to provision VM with arbitrary uploaded predefined files.
$set_working_directory='cd c:\vagrant'
$powershell_args='-ExecutionPolicy ByPass -NoLogo -NonInteractive -NoProfile -Sta'
$import_module='Import-Module vagrant-officeVM'

def ps_elev vm, inline
    vm.provision "shell", name: inline, powershell_args: $powershell_args,
        inline: "#{$set_working_directory};#{$import_module};#{inline};"
end

def ps_nonp vm, inline
    vm.provision "shell", name: inline, powershell_args: $powershell_args, privileged: false,
        inline: "#{$set_working_directory};#{$import_module};#{inline};"
end
