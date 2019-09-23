#!/usr/bin/env bash

docker_context=/root/shared/docker_context

echo "set hosts ..."
echo "
192.30.253.120  codeload.github.com
140.82.114.3    github.com
185.199.111.153 assets-cdn.github.com
199.232.5.194   github.global.ssl.fastly.net
" >> /etc/hosts

if [ -f /etc/init.d/networking ]; then
    /etc/init.d/networking restart
fi

echo "set apt source ..."
cp ${docker_context}/ubuntu/etc/apt/sources.list /etc/apt/sources.list
apt-get update
         
echo "install packages ..."
pkgs="git wget curl make cmake unzip tar autoconf apt-utils \
      libncurses5-dev libgnome2-dev libgnomeui-dev \
      libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
      python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev \
      build-essential texinfo libx11-dev libxpm-dev \
      libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev \
      libgtk-3-dev libncurses-dev libxpm-dev automake autoconf \
      libncurses-dev llvm clang libclang-dev bash-completion \
      htop tree ctags tmux"
apt-get install ${pkgs} -y

echo "set .tmux.conf ..."
cd ${docker_context}
cp ubuntu/home/.tmux.conf ${HOME}

echo "set git buffer ..."
git config --global http.postBuffer 1048576000

