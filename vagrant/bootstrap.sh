#!/usr/bin/env bash

user=vagrant
home_dir=/home/${user}/

# Get env
cd ${home_dir}
if [ ! -d github ]; then
	mkdir github/
	cd github/
fi

if [ -d env ]; then
	cd env
	git pull
	cd -
else
	git clone https://github.com/richard-tai/env.git env
fi

# Get vimrc
if [ ! -f  ${home_dir}/.tmux.conf ]; then
	cd ${home_dir}/github/env/ubuntu/home/
	cp .vimrc ${home_dir}
	cp .tmux.conf ${home_dir}
fi

# Change source
if [ ! -f /etc/apt/sources.list.backup ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.backup
fi
cp ${home_dir}/github/env/ubuntu/etc/sources.list.16.04.ustc /etc/apt/sources.list

# Install package
add-apt-repository ppa:jonathonf/vim -y
add-apt-repository ppa:openjdk-r/ppa -y
#add-apt-repository ppa:apt-fast/stable -y
apt update

#apt-get install -y apt-fast # human interaction needed

apt-get install -y vim

apt-get install -y openjdk-8-jdk
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ${home_dir}/.bashrc

apt-get install -y python-dev
apt-get install -y python3-dev

apt-get install -y ssh

apt-get install -y git
apt-get install -y curl
apt-get install -y tree

apt-get install -y gcc
apt-get install -y g++
apt-get install -y gdb
apt-get install -y clang
apt-get install -y make
apt-get install -y cmake

apt-get install -y screen
apt-get install -y tmux

apt-get install -y ctags
apt-get install -y cscope

apt-get install -y expect
apt-get install -y rsync

apt-get install -y openssl
apt-get install -y graphviz

# Install docker
if [ ! -f /usr/bin/docker ]; then
	wget -qO- https://get.docker.com/ | sh
	usermod -aG docker ${user}
fi

# Get Vundle
cd ${home_dir}
if [ ! -d  .vim/bundle/ ]; then
	mkdir -p .vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
fi

chown -R ${user}:${user} ${home_dir}/.vim

# Generate ssh key
if [ ! -f  ${home_dir}/.ssh/id_rsa ]; then
	su -l ${user} -c "ssh-keygen -t rsa -P '' -f ${home_dir}/.ssh/id_rsa"
	cat ${home_dir}/.ssh/id_rsa.pub >>  ${home_dir}/.ssh/authorized_keys
fi

