lxrun /install /y

lxrun /setdefaultuser root
bash -c @"
   apt update \
&& apt -y upgrade \
&& apt install -y dos2unix g++ g++-mingw-w64-x86-64 git gnupg-agent inotify-tools libcurl4-gnutls-dev make ruby tmux tree zsh \
&& apt -y autoremove

useradd -g users -G sudo -m -s /bin/zsh \
        -p `$(perl -e 'print crypt("vagrant", "tnargav")') vagrant

git config -f /etc/wsl.conf automount.enabled true
git config -f /etc/wsl.conf automount.options metadata
"@

lxrun /setdefaultuser vagrant /y
bash ~ -c @"
   [ ! -L .ssh ] \
&& ln -s /mnt/c/Users/$($env:USERNAME)/.ssh .ssh

   mkdir -p ~/.vim/autoload && mkdir -p ~/.vim/bundle \
&& curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

   git init \
&& git config user.name seb\! \
&& git config user.email sebi@sebi.one.pl \
&& git remote add origin ssh://git@192.168.1.3:9418/sebi/my-babun.git \
&& git fetch --all \
&& git checkout --force bash-on-windows \
&& git reset --hard HEAD \
&& git submodule update --init --recursive \
&& chmod 700 ~/.gnupg && chmod 700 .ssl

   [ -f \"/mnt/c/Program Files/TortoiseGit/bin/TortoiseGitMerge.exe\" ] \
&& git config --global mergetool.tortoisemerge.path \"/mnt/c/Program Files/TortoiseGit/bin/TortoiseGitMerge.exe\" \
&& git config --global merge.tool tortoisemerge

   [ -d /mnt/c/Users/vagrant/MyProjects/soneta ] \
&& git config -f /mnt/c/Users/vagrant/MyProjects/soneta/.git/config oh-my-zsh.hide-dirty 1

   [ -d gitflow ] \
&& cd gitflow \
&& make install prefix=~

   [ -d ~/.tmux/plugins/tpm ] \
&& ~/.tmux/plugins/tpm/bin/install_plugins
"@

Get-VpnConnection |
  % { Add-VpnConnectionTriggerApplication -ConnectionName $_.Name -ApplicationID `
      C:\Windows\system32\bash.exe
  }
