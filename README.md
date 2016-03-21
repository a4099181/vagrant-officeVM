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

