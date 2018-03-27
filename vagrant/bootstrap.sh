#!/usr/bin/env bash

user=vagrant
home_dir=/home/${user}/

add-apt-repository ppa:jonathonf/vim -y
add-apt-repository ppa:openjdk-r/ppa -y
apt update

apt-get install -y vim

apt-get install -y openjdk-8-jdk
cat "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/bin" >> ${home_dir}/.bashrc

apt-get install -y ssh

apt-get install -y git
apt-get install -y curl
apt-get install -y tree

apt-get install -y cmake
apt-get install -y clang

apt-get install -y python-dev
apt-get install -y python3-dev

apt-get install -y screen
apt-get install -y tmux

apt-get install -y ctags
apt-get install -y cscope

apt-get install -y expect
apt-get install -y rsync

# 安装docker
if [ ! -f /usr/bin/docker ]; then
	wget -qO- https://get.docker.com/ | sh
	usermod -aG docker ${user}
fi

# setup env
cd ${home_dir}
if [ ! -d  .vim/bundle/ ]; then
	mkdir -p .vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
fi

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

if [ ! -f  ${home_dir}/.tmux.conf ]; then
	cd env/ubuntu/home/
	cp .vimrc ${home_dir}
	cp .tmux.conf ${home_dir}
fi

chown -R ${user}:${user} ${home_dir}/.vim

su - ${user}
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >>  ~/.ssh/authorized_keys


