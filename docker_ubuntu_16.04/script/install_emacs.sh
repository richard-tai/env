#!/usr/bin/env bash

echo "<<< to install emacs"

docker_context=/root/shared/docker_context
source ${docker_context}/util/setup_common.sh

cd ${docker_context}
unzip -q emacs.zip -d emacs
if [ $? != 0 ]; then
    echo "bad zip"
    exit 1
fi

pkgs="${pkgs} build-essential texinfo libx11-dev libxpm-dev \
    libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev \
    libgtk-3-dev libncurses-dev libxpm-dev automake autoconf \
    libncurses-dev"
apt-get install ${pkgs} -y

echo "build emacs"
cd emacs/emacs-master
./autogen.sh
./configure --prefix=/usr --without-makeinfo --with-gnutls=no --without-x 
make -j 8 && make install

copy_config
install_package

echo "<<< installed emacs"
