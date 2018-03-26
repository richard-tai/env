#!/usr/bin/env bash

sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt update
apt-get install -y vim

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

# 安装docker 1.11.0
if [ ! -f /usr/bin/docker ]; then
	wget -qO- https://get.docker.com/ | sed 's/docker-engine/docker-engine=1.11.0-0~trusty/' | sh
	usermod -aG docker vagrant
fi

# setup env
home_dir=/home/vagrant/
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

chown -R vagrant:vagrant ${home_dir}/.vim


