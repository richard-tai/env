# env

## purpose
* build portable Ubuntu development environment

## environment
* Windows 7 64-bit
* Vagrant 1.9.3
* VirtualBox-5.0.40-115130-Win.exe, **newer version not work as not found by Vagrant**

## build box step
1. run command prompt as administrator
2. cd env/vagrant
3. vagrant up --provision
4. vagrant ssh, **putty needed in Windows**
5. vim ~/.vimrc -> :PluginInstall -> fix ycm error by instruction in ~/.vimrc

## package the box
```
vagrant package
ls ./pakcage.box
```

## using box
```
vagrant box add <new_name> /path/to/package.box
vagrant init <new_name>
```

## Error
+ Fatal Error: Disconnected: No supported authentication methods available (server sent: publickey )
* [vagrant ssh fail when using windows](https://docs-v1.vagrantup.com/v1/docs/getting-started/ssh.html)
* [Log in with an SSH Private Key on Windows](https://support.rackspace.com/how-to/logging-in-with-an-ssh-private-key-on-windows/)
* [download putty puttgen](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
