#!/usr/bin/env bash

echo "<<< to install emacs"

docker_context=/root/shared/docker_context
source ${docker_context}/util/setup_common.sh

cd ${docker_context}
echo ${docker_context}
mkdir emacs
tar -xzf emacs.tar.gz -C emacs
if [ $? != 0 ]; then
    echo "bad tar.gz"
    exit 1
fi

pkgs="${pkgs} build-essential texinfo libx11-dev libxpm-dev \
    libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev \
    libgtk-3-dev libncurses-dev libxpm-dev automake autoconf"
apt-get install ${pkgs} -y

cd emacs-26.3
./configure --prefix=/usr && make -j 8 && make install

copy_config
install_package

echo "<<< installed emacs"
