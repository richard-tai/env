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
