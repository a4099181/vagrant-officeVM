# file    : powershell.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

require "base64"

# My custom solution to provision VM with arbitrary uploaded predefined files.
$set_working_directory='cd c:\vagrant'
$powershell_args='-ExecutionPolicy ByPass -NoLogo -NonInteractive -NoProfile -Sta'
$set_tls='[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol + [System.Net.SecurityProtocolType]::Tls12'

def ps_elev vm, inline
    vm.provision "shell", name: inline, powershell_args: $powershell_args,
        inline: "#{$set_working_directory};#{$set_tls};#{inline};"
end

def ps_nonp vm, inline
    vm.provision "shell", name: inline, powershell_args: $powershell_args, privileged: false,
        inline: "#{$set_working_directory};#{$import_module};#{$set_tls};#{inline};"
end

def ps7_elev vm, inline, wd = "c:\\vagrant"
    enc = Base64.strict_encode64( inline.encode("UTF-16LE") )
    vm.provision "shell", name: inline.lines.first.chomp, powershell_args: $powershell_args,
    inline: "pwsh.exe #{$powershell_args} -WorkingDirectory #{wd} -EncodedCommand #{enc}"
end

def ps7_nonp vm, inline, wd = "c:\\vagrant"
    enc = Base64.strict_encode64( inline.encode("UTF-16LE") )
    vm.provision "shell", name: inline.lines.first.chomp, powershell_args: $powershell_args, privileged: false,
        inline: "pwsh.exe #{$powershell_args} -WorkingDirectory #{wd} -EncodedCommand #{enc}"
end
