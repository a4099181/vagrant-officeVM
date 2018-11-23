## News announcement

This project is now combined with [packer-officeVM].
These both projects together provides full support to:

1. create a [vagrant]'s box on your own (all you need is ISO file of the Windows OS).
2. provision your box to your own virtual machine to work.

[packer-officeVM] is now an integrated part of this project as git submodule.
To read more about [packer-officeVM],
please see it's own [README.md](https://github.com/a4099181/packer-officeVM).

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

    * Microsoft Hyper-V - tested with Windows 10 Hyper-V
    * Oracle VM [VirtualBox] - tested with [VirtualBox] 5.0

  * Secondary must-have requirement is [packer] to be installed on your operating system also.
    It is required to play with [packer-officeVM].

* If you don't want to use any virtualization:

  * Windows should be your operating system.

> _In both cases be a Windows [Powershell] fan_.

### How to use it?

*  If you choose virtualized approach?

   1. Take a copy of this project

      Clone (with submodules) this repo wherever you want using git:

      ```shell
      C:\> git clone --recursive git@github.com/vagrant-officeVM.git
      ```

      If you already have this project cloned and [packer-officeVM] is missing,
      then you should initialize submodules with:

      ```shell
      C:\> git submodule update --init
      ```

      Or alternatively you can use '_Download ZIP_' button
      and unzip the archive wherever you want to.

   2. [Go read about configuration file](#global-configurationcustomization-file) and customize environment.

   3. You need Windows ISO file. You must take care of it on your own.
      After achieve it, place it whenever you want and remember the full path to that ISO file.
      It will be necessary just in the next step.

   4. You need to create a [vagrant]'s box.
      This is the thing where [packer-officeVM] is the best choose.

      Open command line, go to directory where Vagrantfile is and type:

      ```shell
      C:\vagrant-officeVM> cd packer-officeVM
      C:\vagrant-officeVM\packer-officeVM> powershell -ExecutionPolicy ByPass -File build.ps1 <your-iso-file-path>
      ```

      Wait a dozen or so minutes and let [packer] do the box for you.

   5. The last thing is to engage [Vagrant] to create and provision VM to work.

      Stay in the command prompt and get [Vagrant] to work:

      ```shell
      C:\vagrant-officeVM\packer-officeVM> cd ..
      C:\vagrant-officeVM> vagrant up vs2017
      ```

      > Please, note that two technologies are supported.
      > Vagrant uses [VirtualBox] as default so if you want to use Hyper-V,
      > then you have to provide `--provider hyperv` argument.

      Relax and let [Vagrant] to do its job.
      After that your new development environment is ready for you so then:

      ```shell
      C:\vagrant-officeVM\vagrant-officeVM> vagrant rdp
      ```

      and login to your new machine with default credentials.

   Enjoy!

*  If you don't want to use any virtualization?

   I invite you to look at [vagrant-provvin] project.
   This is a set of the [Powershell] modules to provision local Windows instance
   in the same way as this project provisions virtual machine.

   I also recommend to read some informations about
   [configuration file](#global-configurationcustomization-file).

   The same configuration file is used for both solutions.

### Your new virtual machine

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

* install [vagrant-provvin Powershell module](#vagrant-provvin-powershell-module),
* install Nuget package provider for One-Get package management,
* install Newtonsoft.Json package (for configuration files support),
* [merge configuration files](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Merge-ConfigurationFiles.md),
* [chocolatey] package manager installation,
* [install common packages](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Install-CommonPackages.md),
* [download zip files and extract'em](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Expand-DownloadedArchive.md),
* [add Windows credentials](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsCredentials.md),
* [add generic Windows credentials](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-GenericWindowsCredentials.md),
* [install Visual Studio Code extensions](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Install-VisualStudioCodeExtensions.md),
* [connect VPN](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Connect-Vpn.md),
* [clone git repositories](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Copy-GitRepositories.md),
* [install Visual Studio 2017](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Install-VisualStudio2017.md) with strictly specified workloads and components,
* [install Visual Studio 2017 related software](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Install-VisualStudio2017Packages.md),
* [add drive mappings](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-DriveMappings.md),
* [add Windows Defender exclusions](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Add-WindowsDefenderExclusions.md),
* [install Visual Studio 2017 extensions](https://github.com/a4099181/vagrant-provvin/blob/master/docs/Install-VisualStudio2017Extensions.md).
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
  [vpn.psm1](https://github.com/a4099181/vagrant-provvin/blob/master/modules/vpn.psm1)
  maintains VPN triggers.

### Global configuration/customization file

You can customize your machine with a set of the configuration file.
Two configuration files are processed: [config/common.json](config/common.json) and `config/user.json`.
The first one is versioned and shared. It should contain only the most basic and common options.
The second is for user customization. It is not versioned. It is .gitignore-ed.
Both files are merged into one single file at the beginning of the provisioning process.

First-level JSON objects are inputs for different functions
in [vagrant-provvin module](#vagrant-provvin-powershell-module).
[Module's documentation](https://github.com/a4099181/vagrant-provvin/tree/master/docs) describes each of them with configuration samples.

Configuration contains some secret regions where some sensitive datas are expected.
These areas are expected to be encrypted. [vagrant-provvin module](#vagrant-provvin-powershell-module) is eqipped with some
functions to help you play with encryption. See [configuration encryption section](#basic-configuration-encryption).

### Basic configuration encryption

Some objects in JSON formatted configuration file contains object named `secret`.
All values of the `secret`'s properties are recognized as sensitive data.
In particular cases those values holds username or passwords.
You may want upload them into Windows Vault, because:
- you don't want be asked about them,
- or provisioning requires VPN connection,
- or any process running while provisioning needs them to connect somewhere. Maybe to git repository?

When you initially edit your custom configuration file `config\user.json` you enter passwords with plain text.
The next step is to protect your configuration file.
If you do that for the first time, you need your private encryption key, that you don't have.
To create your private key take a powershell console and type:

```powershell
PS (...)\vagrant-officeVM> New-EncryptionKey | Out-File .vagrant\my-private.key

cmdlet New-EncryptionKey at command pipeline position 1
Supply values for the following parameters:
InputFile: <**enter path to any file you want, it will be a source file for your encryption key**>
PS (...)\vagrant-officeVM>
```

And that's all. Now you have your encryption key in `.vagrant\my-private.key`. Take care of that file. Do not share it.
This repository ignores folder `.vagrant` then you won't commit and push anything by mistake.

Now, when you have your encryption key you can protect your configuration file. Back to powershell console and type:

```powershell
PS (...)\vagrant-officeVM> Protect-Config config\user.json .vagrant\my-private.key
PS (...)\vagrant-officeVM>
```

Well done. See config `config\user.json`. It should contains some values like this piece of config file:

```
    "drives":  [
                   {
                       "local":  "M:",
                       "secret":  {
                                      "remote":  "76492d1116743f0423413b16050(...)IEAZQAwADAANwBkADkAMgA5ADUA"
                                  }
                   },
```

Now you can fully provision your new VM and forget about all this stuff until your passwords expires.
When it comes and yo'll want restart your virtual environment, then you'll need to update your secret data.
Before update any protected data you have to unprotect your configuration file. You'll open powershell console and type:

```powershell
PS (...)\vagrant-provvin> Unprotect-Config config\user.json .vagrant\my-private.key
PS (...)\vagrant-provvin>
```

Now your passwords are back. Update the expired passwords and protect it back. After that `vagrant up` command will have a chance to succeed again.
As you see your encryption key guarantees bi-directional operation protect<->unprotect.
If you throw off your encryption key you have restore your secret data yourself.

All functions involved are members of [vagrant-provvin module](#vagrant-provvin-powershell-module).

### vagrant-provvin [Powershell] module

All [Powershell] scripts useful while provisionig are assembled together
into single [Powershell] module called `vagrant-provvin`.
You can take a [Powershell] console and invoke on-demand any single function you want at any time you want.
The module is installed on provisioned VM at location where it can be automatically imported from.
If you want to use any function on your local machine you have to import taht module manually with command like:

```powershell
PS (...)\vagrant-officeVM> Import-Module vagrant-provvin\vagrant-provvin.psd1
PS (...)\vagrant-officeVM>
```

[vagrant-provvin] is a separate project which together with: [vagrant-officeVM] and [packer-officeVM]
forms one ecosystem.
The source code of the module you can find [here](https://github.com/a4099181/vagrant-provvin)
and full documentation is exposed [here](https://github.com/a4099181/vagrant-provvin/tree/master/docs).

Enjoy :)

[Babun]: http://babun.github.io
[Chocolatey]: https://chocolatey.org
[Git]: https://git-scm.com/
[inconsolata]: http://www.levien.com/type/myfonts/inconsolata.html
[Java]: http://www.java.com
[meslo]: https://github.com/andreberg/Meslo-Font
[packer]: http://packer.io
[packer-officeVM]: https://github.com/a4099181/packer-officeVM
[vagrant-provvin]: https://github.com/a4099181/vagrant-provvin
[vagrant-officeVM]: https://github.com/a4099181/vagrant-officeVM
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
