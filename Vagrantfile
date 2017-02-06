# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "provision/ruby/powershell.rb"

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
    config.vm.box          = "your-box-name-here"
    config.vm.box_url      = "your-box-url-here"
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

  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = memory

      vb.cpus = [1, ENV['NUMBER_OF_PROCESSORS'].to_i - 1 ].max

  end

  config.vm.provider "hyperv" do |hv|

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

  cfg_file='cfg.json'
  key_file='.vagrant\my-private.key'

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  ps_elev config.vm, 'robocopy provision\powershell "C:\Users\vagrant\Documents\WindowsPowerShell\Modules\vagrant-officeVM" *.ps?1 /MIR'
  ps_elev config.vm, '("Nuget") | ?{@(Get-PackageProvider $_ -ErrorAction Ignore).Count -eq 0} | %{Install-PackageProvider $_ -Force}'
  ps_elev config.vm, '("newtonsoft.json") | ?{@(Get-Package $_ -ErrorAction Ignore).Count -eq 0} | %{Install-Package $_ -Force}'
  ps_elev config.vm, "Merge-ConfigurationFiles config\\common.json, config\\user.json | Out-File -Encoding utf8 #{cfg_file}"
  ps_elev config.vm, 'Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression'
  ps_elev config.vm, "Install-CommonPackages #{cfg_file}"
  ps_elev config.vm, 'robocopy sysroot c:\ /S /NDL /NFL' if Dir.exist? 'sysroot'
  ps_elev config.vm, "Add-WindowsCredentials #{cfg_file} #{key_file}"
  ps_elev config.vm, "Add-GenericWindowsCredentials #{cfg_file} #{key_file}"
  ps_nonp config.vm, "Install-VisualStudioCodeExtensions #{cfg_file}"
  ps_nonp config.vm, "Connect-Vpn #{cfg_file} #{key_file} 'Soneta VPN'"
  ps_elev config.vm, "Copy-GitRepositories #{cfg_file}"

  config.vm.define 'vs2017', autostart: false, primary: false do | vs17 |

      ps_elev vs17.vm, "Install-VisualStudio2017 #{cfg_file}"
      ps_elev vs17.vm, "Install-VisualStudio2017Packages #{cfg_file}"
      ps_elev vs17.vm, "FORFILES /P provision\\registry /M *.reg /S /C 'cmd /c regedit /S @path'"
      ps_elev vs17.vm, 'Add-SystemPath( @( Join-Path $ENV:UserProfile bin ) )'
      ps_elev vs17.vm, "Add-DriveMappings #{cfg_file} #{key_file}"
      ps_elev vs17.vm, 'Add-WindowsDefenderExclusions'
      ps_nonp vs17.vm, "Install-VisualStudio2017Extensions #{cfg_file}"

  end

  # Vagrantfile custom global provisioning place-holders
  # STARTS-HERE
  # ENDS-HERE

end
