### Requirements

* Must-have requirement is [Vagrant] to be installed on your operating system.
  You can download it from https://www.vagrantup.com/downloads.html
  and follow the installer to install it.

* Soft requirement is **Hyper-V** to be active on your operating system.
  This machine arbitrary uses a box based on **Hyper-V** solution by default.
  It is possible to use any other virtualization provider such as **VMWare**
  or **Virtual Box**. In this case valid box should be provided.
  This box should contain any Windows operating system.

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

[Vagrant]: https://www.vagrantup.com
