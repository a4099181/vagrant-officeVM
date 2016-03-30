> See **[known issues](#known-issues)** at the bottom of this page, please.

### Requirements

* Must-have requirement is [Vagrant] to be installed on your operating system.
  You can download it from https://www.vagrantup.com/downloads.html
  and follow the installer to install it.

* Soft requirement is **Hyper-V** to be active on your operating system.
  This machine arbitrary uses a box based on **Hyper-V** solution by default.
  It is possible to use any other virtualization provider such as **VMWare**
  or **Virtual Box**. In this case valid box should be provided.
  This box should contain any Windows operating system just only.

### How to use it?

1. Get _Vagrantfile_

   Clone this repo wherever you want using git:

   ```shell
   C:\my-vagrant> git clone git@github.com/Vagrant.MyDevMachine.git
   ```

   Or alternatively you can use '_Download ZIP_' button
   and unzip the archive wherever you want to.

2. Open command line as Administrator,
   go to directory where Vagrantfile is stored
   and get [Vagrant] to work:

   ```shell
   C:\my-vagrant\Vagrant.MyDevMachine> vagrant up
   ```

   Relax and let [Vagrant] to do its job.
   After that your new development environment is ready for you so then:

   ```shell
   C:\my-vagrant\Vagrant.MyDevMachine> vagrant rdp
   ```

   and login to your new machine with default credentials.

   Enjoy!

### Your new machine

* has a hostname as your host OS with suffix `-VAGRANT`
* has assigned 1 CPU less than your host OS has.
* has declared maximum memory up to 8GB

> These all settings you can tweak as you wish.

### What is installed?

* VPN connection
* NuGet extended configuration

#### [Chocolatey] packages:

It reads a list of packages to install from
[packages.config](../master/provision/choco/packages.config)

* Applications:
  * [Git] Portable
  * [Skype]
  * [Tomighty] - it installs [Java] Runtime Environment
  * [Visual Studio] 2015 Enterprise Update 1 with optional features:
    * SQL
  * [Resharper] - [Visual Studio] extension for .net developers
* Fonts:
  * [inconsolata]
  * [meslo]
  * [source code pro]
* Utilities:
  * [unzip]

#### Visual Studio extensions

It reads a list of Visual Studio extensions to install from
[vs-extensions.txt](../master/provision/vs-extensions.txt)

* [File nesting]
* [Productivity Power Tools]
* [ReAttach]
* [Relative line numbers]
* [Soneta StudioExt Package]
* [Visual Studio Spell Checker]
* [VSColorOutput]
* [VsVim]

### Drives mappings

There is expected an encrypted file `sysroot-protected`
inside `sysroot-protected\Users\Vagrant\AppData\Local\Temp` folder.

Decrypted content should be a JSon formatted data like below:

```json
    {     "mappings" : [ {
          "local"    :     "<localDrive>"
      ,   "remote"   :     "\\\\<server-name>\\<network-share>"
      ,   "username" :     "<username>"
      ,   "password" :     "<password>"
    } ] }
```

This file is processed by
[map-drives.ps1](../master/provision/powershell/map-drives.ps1) while provisioning.

### Sensitive data support

Sensitive data such as usernames and passwords are protected with encryption.
All files located in `sysroot-protected` folder are expected to be encrypted.
This folder is processed by
[sysroot-protected.ps1](../provisioning/powershell/sysroot-protected.ps1).
This scripts supports file content encryption with a key provided as file.

### What will be installed on first login?

* [Babun] - a Windows shell you will love

### Known issues!

* Visual Studio installation issue

  Visual Studio installation fails but Visual Studio is installed anyway :).
  This failure stops provisioning.
  There is a workaround for it:

  ```shell
  > vagrant up
  (...) # vagrant will build the virtual machine and stops after Visual Studio installation.
  > vagrant provision
  (...) # it cause re-provisioning and it should succeed.
  > vagrant rdp # and enjoy!
  ```

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
[Visual Studio]: https://www.visualstudio.com

[File nesting]: http://visualstudiogallery.msdn.microsoft.com/3ebde8fb-26d8-4374-a0eb-1e4e2665070c
[Productivity Power Tools]: http://visualstudiogallery.msdn.microsoft.com/d0d33361-18e2-46c0-8ff2-4adea1e34fef
[ReAttach]: http://visualstudiogallery.msdn.microsoft.com/8cccc206-b9de-42ef-8f5a-160ad0f017ae
[Relative line numbers]: http://visualstudiogallery.msdn.microsoft.com/74d68e2b-ff64-4c51-a2ed-d8b164eee858
[Soneta StudioExt Package]: http://visualstudiogallery.msdn.microsoft.com/d0a1ac45-15b9-4471-acaf-df650bf937d5
[Visual Studio Spell Checker]: http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff
[VSColorOutput]: http://visualstudiogallery.msdn.microsoft.com/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496
[VsVim]: http://visualstudiogallery.msdn.microsoft.com/59ca71b3-a4a3-46ca-8fe1-0e90e3f79329
