### What is it for?

Fast and easy software developer's environment setup. 
Be able to:
* start to code up to one hour from scratch (ie: just after new OS installation),
* decide to restart your development environment any time you want 
  and after next one hour enjoy your new development environment
  and back to code ;)

Make simply possible two alternative approaches:
* get full power of advantages using virtualization you like,
* work with local Windows instance and make your new computer ready to work ASAP.

### Requirements

* If you choose virtualized approach:

  * Must-have requirement is [Vagrant] to be installed on your operating system.
    You can download it from https://www.vagrantup.com/downloads.html
    and follow the installer to install it.

  * This [Vagrantfile] supports:

    * Microsoft HyperV - tested with Windows 10 HyperV
    * Oracle VM [VirtualBox] - tested with [VirtualBox] 5.0

    It is possible to use any other virtualization provider such as **VMWare**.
  
  * You must have a copy of virtualized Windows instance.
    It is a little bit complicated thing to do but it is a one-time job to do.
    Take a virtualization hypervisor you like and create new virtualized Windows.
    This is your vagrant box.
    This box should contain any Windows operating system configured as it is
    described in Vagrant documentation in chapter
    [Creating a base box](https://www.vagrantup.com/docs/boxes/base.html).

    Alternatively you can go look for a box at [Atlas](https://atlas.hashicorp.com/boxes/search)
    and just download it.

    Another good option is to share a box across the developers at your company.

* If you don't want to use any virtualization:

  * Windows should be your operating system.

> _In both cases be a Windows [Powershell] fan_.

### How to use it?

1. Take a copy of this project

   Clone this repo wherever you want using git:

   ```shell
   C:\my-vagrant> git clone git@github.com/vagrant-officeVM.git
   ```

   Or alternatively you can use '_Download ZIP_' button
   and unzip the archive wherever you want to.

2. [Go read about configuration file](#global-configurationcustomization-file) and customize environment.

3. If you choose virtualized approach?

   Open command line, go to directory where Vagrantfile is stored
   and get [Vagrant] to work:

   ```shell
   C:\my-vagrant\vagrant-officeVM> vagrant up --provider hyperv
   ```

   > Please, note that two technologies are supported.
   > Vagrant uses [VirtualBox] as default so if you want to use HyperV,
   > then you have to provide `--provider hyperv` argument.

   Relax and let [Vagrant] to do its job.
   After that your new development environment is ready for you so then:

   ```shell
   C:\my-vagrant\vagrant-officeVM> vagrant rdp
   ```

   and login to your new machine with default credentials.

   Enjoy!

4. If you don't want to use any virtualization?
   
   Take a short look at [setup.ps1](setup.ps1) and execute it if you trust it.

### Your new virtual machine

  * has a hostname as your host OS with suffix `-V`
  * has assigned 1 CPU less than your host OS has.
  * has declared maximum memory up to 8GB and not more than 2/3 of your total RAM size.

  > All these settings you can tweak as you wish.

### Multi-machine support

A single Vagrantfile may describe more than one machine. Two or more concurrent
versions of software may be provisioned in separated virtual machines.

The [Vagrantfile] specifies following machines:

* `vs2015` - **REMOVED** machine with [Visual Studio] 2015.
* `vs2017` - the machine with [Visual Studio] 2017.
  In the future, when new releases of the [Visual Studio] will come new
  dedicated machines are expected and may be separated from each other.

### Provisioning process

Provisioning process is a sequence of operations as follows:

> Follow links to get more information about each operation and [Powershell] function involved.

* install [vagrant-officeVM Powershell module](#vagrant-officevm-powershell-module),
* install Nuget package provider for One-Get package management,
* install Newtonsoft.Json package (for configuration files support),
* [merge configuration files](docs/Merge-ConfigurationFiles.md),
* [chocolatey] package manager installation,
* [install common packages](docs/Install-CommonPackages.md),
* [add Windows credentials](docs/Add-WindowsCredentials.md),
* [add generic Windows credentials](docs/Add-GenericWindowsCredentials.md),
* [install Visual Studio Code extensions](docs/Install-VisualStudioCodeExtensions.md),
* [connect VPN](docs/Connect-Vpn.md),
* [clone git repositories](docs/Copy-GitRepositories.md),
* [install Visual Studio 2017](docs/Install-VisualStudio2017.md) with strictly specified workloads and components,
* [install Visual Studio 2017 related software](docs/Install-VisualStudio2017Packages.md),
* [add drive mappings](docs/Add-DriveMappings.md),
* [add Windows Defender exclusions](docs/Add-WindowsDefenderExclusions.md),
* [install Visual Studio 2017 extensions](docs/Install-VisualStudio2017Extensions.md).
* mirror [sysroot](sysroot) folder into `c:\`,

  There is some software that cannot be installed while provisioning.
  This method is used to provide a desktop shortcut to do a manual installation.

  For example [Get Babun desktop shortcut](sysroot/Users/vagrant/Desktop)
  simplifies [Babun] installation and needs to be manually clicked. [Babun]
  installation is supported by Powershell script
  [babun.ps1](provision/powershell/babun.ps1).

* import registry keys from [provision/registry](provision/registry),

  This is another method to take some actions in runtime of your new machine.

  For example [vpn-triggers.reg](provision/registry/vpn-triggers.reg)
  registers an action to update VPN application triggers. You don't have to
  manually connect VPN connection. It will be established automatically when
  specified executable files will be executed. Triggers are updated every time
  the user is logged in and Powershell script
  [vpn.psm1](provision/powershell/vpn.psm1)
  maintains VPN triggers.

### Global configuration/customization file

You can customize your machine with a set of the configuration file.
Two configuration files are processed: [config/common.json](config/common.json) and `config/user.json`.
The first one is versioned and shared. It should contain only the most basic and common options.
The second is for user customization. It is not versioned. It is .gitignore-ed.
Both files are merged into one single file at the beginning of the provisioning process.

First-level JSON objects are inputs for different functions
in [vagrant-officeVM module](#vagrant-officevm-powershell-module).
[Module's documentation](docs) describes each of them with configuration samples.

Configuration contains some secret regions where some sensitive datas are expected.
These areas are expected to be encrypted with tools available in [Utils](utils) folder.

The first step you need is to make your own copy of the configuration file. You should store there your passwords and usernames.
The next thing is to encrypt this file.

You need a private key. You can create it with [Generate-PrivateKey](utils/Generate-PrivateKey.ps1) utility.
Then you can encrypt the file with [Encrypt-Config](utils/Encrypt-Config.ps1).

When your passwords needs to be changed you can decrypt the file with [Decrypt-Config](utils/Decrypt-Config.ps1). Then update the configuration and encrypt it back. That's all.

It is recommended to maintain your configuration file in your own branch or fork.

### vagrant-officeVM [Powershell] module

All [Powershell] scripts useful while provisionig are assembled together 
into single [Powershell] module called `vagrant-officeVM`. 
You can take a [Powershell] console and invoke on-demand any single function you want at any time you want.
The module is installed at location where it can be automatically imported from.

The source code of the module you can find [here](provision/powershell) 
and full documentation is exposed [here](docs).

[Babun]: http://babun.github.io
[Chocolatey]: https://chocolatey.org
[Git]: https://git-scm.com/
[inconsolata]: http://www.levien.com/type/myfonts/inconsolata.html
[Java]: http://www.java.com
[meslo]: https://github.com/andreberg/Meslo-Font
[PowerShell]: https://pl.wikipedia.org/wiki/Windows_PowerShell
[Resharper]: https://www.jetbrains.com/resharper/
[Skype]: http://www.skype.com
[source code pro]: http://adobe-fonts.github.io/source-code-pro/
[Tomighty]: http://www.tomighty.org
[unzip]: http://www.info-zip.org/UnZip.html
[Vagrant]: https://www.vagrantup.com
[Vagrantfile]: Vagrantfile
[Visual Studio]: https://www.visualstudio.com
[Visual Studio Code]: https://code.visualstudio.com
[VirtualBox]: https://www.virtualbox.org

[File nesting]: http://visualstudiogallery.msdn.microsoft.com/3ebde8fb-26d8-4374-a0eb-1e4e2665070c
[Productivity Power Tools]: http://visualstudiogallery.msdn.microsoft.com/d0d33361-18e2-46c0-8ff2-4adea1e34fef
[ReAttach]: http://visualstudiogallery.msdn.microsoft.com/8cccc206-b9de-42ef-8f5a-160ad0f017ae
[Relative line numbers]: http://visualstudiogallery.msdn.microsoft.com/74d68e2b-ff64-4c51-a2ed-d8b164eee858
[Soneta StudioExt Package]: http://visualstudiogallery.msdn.microsoft.com/d0a1ac45-15b9-4471-acaf-df650bf937d5
[Visual Studio Spell Checker]: http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff
[VSColorOutput]: http://visualstudiogallery.msdn.microsoft.com/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496
[VsVim]: http://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329
