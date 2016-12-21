### Requirements

* Must-have requirement is [Vagrant] to be installed on your operating system.
  You can download it from https://www.vagrantup.com/downloads.html
  and follow the installer to install it.

* This [Vagrantfile] supports:

  * Microsoft HyperV - tested with Windows 10 HyperV
  * Oracle VM [VirtualBox] - tested with [VirtualBox] 5.0

  It is possible to use any other virtualization provider such as **VMWare**.
  In this case valid box should be provided.
  This box should contain any Windows operating system configured as it is
  described in Vagrant documentation in chapter
  [Creating a base box](https://www.vagrantup.com/docs/boxes/base.html).

### How to use it?

1. Get _Vagrantfile_

   Clone this repo wherever you want using git:

   ```shell
   C:\my-vagrant> git clone git@github.com/vagrant-officeVM.git
   ```

   Or alternatively you can use '_Download ZIP_' button
   and unzip the archive wherever you want to.

2. Open command line as Administrator,
   go to directory where Vagrantfile is stored
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

   > It is adviced to clean local temporary folder after successful machine
   > provisioning. It will free some disk space (more than 1GB I expect)
   > and may remove some sensitive data used for provisioning.

### Your new machine

  * has a hostname as your host OS with suffix `-V`
  * has assigned 1 CPU less than your host OS has.
  * has declared maximum memory up to 8GB

  > All these settings you can tweak as you wish.

### Multi-machine support

A single Vagrantfile may describe more than one machine. Two or more concurrent
versions of software may be provisioned in separated virtual machines.

The [Vagrantfile] specifies following machines:

* `vs2015` - the primary machine with [Visual Studio] 2015.
  In the future, when new releases of the [Visual Studio] will come new
  dedicated machines are expected and may be separated from each other.
* `vs2017` - The future is now ;-) Another machine with [Visual Studio] 2017.

### Common provisioning

While provisioning all machines installs:

* [Chocolatey] package manager
* [Chocolatey] packages specified in
  [choco.config](../master/provision/generic/choco.config)

Each vagrant machine may be provisioned individual also.

### Individual provisioning

##### `vs2017`

This particular machine is equipped with:

* [Chocolatey] packages specified in
  [choco.config](../master/provision/vs2017/choco.config)
* [Visual Studio] is installed exclusively by Powershell script
  [install.ps1](../master/provision/vs2017/install.ps1)
* [Visual Studio] extensions specified in
  [vs-marketplace.txt](../master/sysroot/Users/vagrant/AppData/Local/Temp/vs-marketplace.txt).
  Extensions are installed by Powershell script
  [vsix-marketplace.ps1](../master/provision/powershell/vsix-marketplace.ps1).
* All other items are handled the same way as `vs2015` (described below)

  > Please note, that Visual Studio 2017 is deployed with:
  > - new setup tool; this changes the way VS2017 may be installed silently with custom features.
  >   It is supported by the script [install.ps1](../master/provision/vs2017/install.ps1)
  > - VS Marketplace as new extensions' gallery; this changes the way VS2017 may be extended.
  >   It is supported by the script [vsix-marketplace.ps1](../master/provision/powershell/vsix-marketplace.ps1)
  >   and input file [vs-marketplace.txt](../master/sysroot/Users/vagrant/AppData/Local/Temp/vs-marketplace.txt).

##### `vs2015`

This particular machine is equipped with:

* [Chocolatey] packages specified in
  [choco.config](../master/provision/vs2015/choco.config)
* [Visual Studio] extensions specified in
  [vs-extensions.txt](../master/sysroot/Users/vagrant/AppData/Local/Temp/vs-extensions.txt).
  Extensions are installed by Powershell script
  [vsix.ps1](../master/provision/powershell/vsix.ps1).

* [Visual Studio Code] extensions specified in
  [vscode-extensions.txt](../master/sysroot/Users/vagrant/AppData/Local/Temp/vscode-extensions.txt).
  Extensions are installed by Powershell script
  [vscode.ps1](../master/provision/powershell/vscode.ps1).

* all arbitrary files from [sysroot](../master/sysroot) folder.
  This folder is processed by file replication command `robocopy` available
  in Windows operating system.

  There is some software that cannot be installed while provisioning.
  This method is used to provide a desktop shortcut to do a manual installation.

  For example [Get Babun desktop shortcut](../master/sysroot/Users/vagrant/Desktop)
  simplifies [Babun] installation and needs to be manually clicked. [Babun]
  installation is supported by Powershell script
  [babun.ps1](../master/provision/powershell/babun.ps1).

  Take a look inside [sysroot](../master/sysroot/) to see what else will be
  copied to your new machine.

* all files from [sysroot-protected](../master/sysroot-protected) folder.
  Files are expected to be encrypted using a custom utility
  [Encrypt-Json.ps1](../master/utils/Encrypt-Json.ps1). Files are processed by
  Powershell script
  [sysroot-protected.ps1](../master/provision/powershell/sysroot-protected.ps1).

  That is the way the sensitive private data are being applied into guest OS.
  This is the way to maintain privacy and secure those data also.

* all `*.reg` files from [registry](../master/provision/registry) folder are
  applied using a batch file
  [registry.cmd](../master/provision/batch/registry.cmd).

  This is another method to take some actions in runtime of your new machine.

  For example [vpn-triggers.reg](../master/provision/registry/vpn-triggers.reg)
  registers an action to update VPN application triggers. You don't have to
  manually connect VPN connection. It will be established automatically when
  specified executable files will be executed. Triggers are updated every time
  the user is logged in and Powershell script
  [vpn-triggers.ps1](../master/provision/powershell/vpn-triggers.ps1)
  maintains VPN triggers.

* Windows credentials. Credentials list is processed by
  [vault.ps1](../master/provision/powershell/vault.ps1).
  [More info...](#windows-credentials)

* established VPN connection. Only when `vpn-connect.cmd` is provided.
  [More info...](#vpn-connection)

* mapped network drives. [More info...](#drives-mappings)

* cloned git repositories. You can define a list of git repositories in file
  [git-clone.json](../master/sysroot/Users/vagrant/MyProjects/git-clone.json).
  This file is processed by Powershell script
  [git-clone.ps1](../master/provision/powershell/git-clone.ps1).

  > Target directory for cloned repositories is `%USERPROFILE%\MyProjects` on guest OS.

* Windows Defender exclusions. There is a Powershell script
  [defender.ps1](../master/provision/powershell/defender.ps1) that looks for
  some executables. Those files are ignored by Windows Defender anti-malware
  scanner.

### VPN connection

It is possible to establish VPN connection while provisioning.
Two files are required:

1. `rasphone.pbk` placed into user application data folder
   using `sysroot` solution.
2. encrypted `vpn-connect.cmd` batch file placed into temporary folder
   using `sysroot-protected` solution.

   `vpn-connect.cmd` batch file should contain encrypted single line as below:

   ```shell
   rasdial "<VPN connection name>" <username> <password> /domain:<domain name>
   ```

> Note, that it will be supported by the global configuration file soon.

### Windows credentials

There is expected an encrypted file `vault.json`
inside `sysroot-protected\Users\Vagrant\AppData\Local\Temp` folder.

Decrypted content should be a JSon formatted data like below:

```json
    {     "credentials" : [ {
          "type"     :     "domain"
      ,   "server"   :     "<servername>"
      ,   "username" :     "<username>"
      ,   "password" :     "<password>"
      }, {
          "type"     :     "generic"
      ,   "server"   :     "git:http://<url>:<port>"
      ,   "username" :     "<username>"
      ,   "password" :     "<password>"
      }, {
          "type"     :     "dialup"
      ,   "name"     :     "<vpn connection name>"
      ,   "username" :     "<username>"
      ,   "password" :     "<password>"
    } ] }
```

While provisioning this file is processed by multiple scripts such as:
[vault-dialup.ps1](../master/provision/powershell/vault-dialup.ps1)
, [vault-domain.ps1](../master/provision/powershell/vault-domain.ps1)
, [vault-generic.ps1](../master/provision/powershell/vault-generic.ps1)
.

> Note, that it will be supported by the global configuration file soon.

### Drives mappings

There is expected an encrypted file `map-drives.json`
inside `sysroot-protected\Users\Vagrant\AppData\Local\Temp` folder.

Decrypted content should be a JSon formatted data like below:

```json
    {     "drives" : [ {
          "local"    :     "<localDrive>"
      ,   "remote"   :     "\\\\<server-name>\\<network-share>"
    } ] }
```

This file is processed by
[map-drives.ps1](../master/provision/powershell/map-drives.ps1) while provisioning.

> Note, that it will be supported by the global configuration file soon.

### Global configuration/cutomization file

You can customize your machine with single configuration file.
The file is JSON formatted. A sample configuration file is
[cfg.json](../sebi/cfg.json).

Configuration contains some secret regions where some sensitive datas are expected.
These areas are expected to be encrypted with tools available in [Utils](../master/utils/) folder.

The first step you need is to make your own copy of the configuration file. You should store there your passwords and usernames.
The next thing is to encrypt this file.

You need a private key. You can create it with [Generate-PrivateKey](../master/utils/Generate-PrivateKey.ps1) utility.
Then you can encrypt the file with [Encrypt-Config](../master/utils/Encrypt-Config.ps1).

When your passwords needs to be changed you can decrypt the file with [Decrypt-Config](../master/utils/Decrypt-Config.ps1). Then update the configuration and encrypt it back. That's all.

It is recommended to maintain your configuration file in your own branch or fork.

[Babun]: http://babun.github.io
[Chocolatey]: https://chocolatey.org
[Git]: https://git-scm.com/
[inconsolata]: http://www.levien.com/type/myfonts/inconsolata.html
[Java]: http://www.java.com
[meslo]: https://github.com/andreberg/Meslo-Font
[Resharper]: https://www.jetbrains.com/resharper/
[Skype]: http://www.skype.com
[source code pro]: http://adobe-fonts.github.io/source-code-pro/
[Tomighty]: http://www.tomighty.org
[unzip]: http://www.info-zip.org/UnZip.html
[Vagrant]: https://www.vagrantup.com
[Vagrantfile]: ../master/Vagrantfile
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
