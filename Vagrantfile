# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "provision/ruby/git-clone.rb"
require_relative "provision/ruby/sysroot.rb"
require_relative "provision/ruby/sysroot-protected.rb"
require_relative "provision/ruby/vpn-connect.rb"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
    config.vm.provider       "virtualbox"
    config.vm.box          = "seb!/w10box"
    config.vm.box_url      = "https://cdn.rawgit.com/a4099181/vagrant-w10box/master/remote-box.json"
    config.vm.hostname     = "#{ENV['COMPUTERNAME']}-V"
    config.vm.guest        = :windows
    config.vm.communicator = "winrm"
    config.winrm.username  = "vagrant"
    config.winrm.password  = "vagrant"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3389, host: 33890

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  totalmemory = `wmic os get TotalVisibleMemorySize | grep '^[0-9]'`.to_i / 1024
  memory      = [8192, totalmemory * 2 / 3].min

  config.vm.provider "virtualbox" do |vb|

      vb.name = "#{ENV['COMPUTERNAME']}-V"

  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = memory

      vb.cpus = [1, ENV['NUMBER_OF_PROCESSORS'].to_i - 1 ].max

  end

  config.vm.provider "hyperv" do |hv|

      hv.vmname = "#{ENV['COMPUTERNAME']}-V"

      # Number of virtual CPU given to mashine.
      # Defaults is taken from box image XML.
      hv.cpus = [1, ENV['NUMBER_OF_PROCESSORS'].to_i - 1 ].max

  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"

      # Number of MegaBytes maximal allowed to allocate for VM
      # This parameter is switch on Dynamic Allocation of memory.
      # Defaults is taken from box image XML.
      hv.maxmemory = memory
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision 'shell', name: 'generic: chocolatey provisioner',
      run: 'up', powershell_args: '-ExecutionPolicy ByPass',
      inline: "iex ((new-object net.webclient)" +
              ".DownloadString('https://chocolatey.org/install.ps1'))"

  config.vm.provision 'shell', name: 'generic: chocolatey packages',
      run: 'up', powershell_args: '-NoProfile -ExecutionPolicy ByPass',
      inline: 'cinst --allow-empty-checksums -y C:\vagrant\provision\generic\choco.config'

  config.vm.define 'vs2015', autostart: true, primary: true do | main |

      main.vm.provision 'shell', name: 'vs2015: chocolatey packages',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          inline: 'cinst --allow-empty-checksums --timeout 14400 -y C:\vagrant\provision\vs2015\choco.config'

      provision_sysroot            main.vm if Dir.exist?  'sysroot'

      provision_sysroot_protected  main.vm if Dir.exist?  'sysroot-protected'

      main.vm.provision 'shell', name: 'vs2015: vs extensions',
          privileged: false,
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\vsix.ps1'

      main.vm.provision 'shell', name: 'vs2015: vscode extensions',
          privileged: false,
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\vscode.ps1'

      main.vm.provision 'shell', name: 'Windows Registry update',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          privileged: true, run: 'up', path: 'provision\batch\registry.cmd'

      main.vm.provision 'shell', name: 'vs2015: Windows credentials',
          path: 'provision\powershell\vault-domain.ps1'

      main.vm.provision 'shell', name: 'vs2015: Windows generic credentials',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\vault-generic.ps1'

      main.vm.provision 'shell', name: 'vs2015: dialup credentials',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\vault-dialup.ps1'

      main.vm.provision 'shell', name: 'Extend PATH variable',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\extend-PATH-environment-variable.ps1'

      connect_vpn                  main.vm

      main.vm.provision 'shell', name: 'vs2015: network drives',
          powershell_args: '-NoProfile -ExecutionPolicy ByPass -NonInteractive',
          privileged: true,
          run: 'up', path: 'provision\powershell\map-drives.ps1'

      provision_gitclone           main.vm if File.exist? 'sysroot\Users\vagrant\MyProjects\git-clone.json'

      main.vm.provision 'shell', name: 'Windows Defender exclusions',
          run: 'up', powershell_args: '-NoProfile -ExecutionPolicy ByPass',
          path: 'provision\powershell\defender.ps1'

  end
end
