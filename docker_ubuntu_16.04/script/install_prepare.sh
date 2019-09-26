#!/usr/bin/env bash

start_time=$(date +"%s")
echo "enter [$0]."

source util/utils.sh

echo "set hosts ..."
echo " \
192.30.253.120  codeload.github.com \
140.82.114.3    github.com \
185.199.111.153 assets-cdn.github.com \
199.232.5.194   github.global.ssl.fastly.net \
" >> /etc/hosts

if [ -f /etc/init.d/networking ]; then
    /etc/init.d/networking restart
fi

echo "set apt source ..."
cp ${docker_context}/ubuntu/etc/apt/sources.list /etc/apt/sources.list
apt-get update
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
         
echo "install packages ..."
pkgs="git wget curl make cmake unzip tar autoconf apt-utils \
      libncurses5-dev libgnome2-dev libgnomeui-dev \
      libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxt-dev python-dev \
      python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev \
      build-essential texinfo libx11-dev libidn11-dev libcppunit-dev \
      libjpeg-dev libpng-dev libgif-dev libtiff-dev \
      libgtk-3-dev libncurses-dev libxpm-dev automake autoconf \
      libncurses-dev llvm clang libclang-dev bash-completion \
      htop tree tmux ssh python-dev tree gcc g++ gdb screen \
      ctags cscope expect rsync openssl graphviz graphviz-dev \
      libcppunit-doc dos2unix python-pycurl libcurl4-gnutls-dev \
      net-tools libssl-dev autoconf zlib1g-dev libbz2-dev pstack \
      openjdk-8-jdk libqt4-dev pkg-config libavcodec-dev libavformat-dev \
      libswscale-dev libopenblas-base libsdl2-dev libsdl2-image-dev \
      libdc1394-22-dev cmake-qt-gui libgnutls-dev libtiff5-dev \
      inetutils-ping"
apt-get install ${pkgs} -y >/dev/null
if [[ $? -ne 0 ]]; then
    echo "install fail."
    exit 1
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "set .tmux.conf ..."
cd ${docker_context}
cp ubuntu/home/.tmux.conf ${HOME}

echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
echo "leave [$0]."

