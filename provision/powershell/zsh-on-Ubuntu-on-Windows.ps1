ubuntu2004.exe install --root

ubuntu2004.exe config --default-user root
bash -c @"
   apt-get update \
&& apt-get -y upgrade \
&& apt-get install -y dos2unix g++ g++-mingw-w64-x86-64 git gnupg-agent inotify-tools libcurl4-gnutls-dev make ruby tmux tree zsh \
&& apt-get -y autoremove

   grep vagrant /etc/passwd \
|| useradd -g users -G sudo -m -s /bin/zsh \
   -p `$(perl -e 'print crypt("vagrant", "tnargav")') vagrant

git config -f /etc/wsl.conf automount.enabled true
git config -f /etc/wsl.conf automount.options metadata

   [ -d /home/vagrant ] \
&& cp -r /mnt/c/Users/vagrant/.ssh /home/vagrant/.ssh \
&& chown -R vagrant:users /home/vagrant/.ssh \
&& chmod -R 700 /home/vagrant/.ssh \
&& chmod u-x /home/vagrant/.ssh/* \
&& chmod u-w /home/vagrant/.ssh/id_rsa
"@

ubuntu2004.exe config --default-user vagrant
bash ~ -c @"
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
  ForEach-Object { Add-VpnConnectionTriggerApplication -ConnectionName $_.Name -ApplicationID `
      (Get-Command bash).Source
  }
