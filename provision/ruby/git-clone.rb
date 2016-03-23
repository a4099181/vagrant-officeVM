# file    : git-clone.rb
# author  : seb! <sebi@sebi.one.pl>
# license : MIT

# My custom solution to clone git repositories.
# More details in powershell\git-clone.ps1

def provision_gitclone vm
    vm.provision 'shell', name: 'git-clone.[ rb | ps1 ]', run: 'up',
        path: 'provision\powershell\git-clone.ps1'
end
