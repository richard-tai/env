#!/usr/bin/env bash

echo "<<< to install spf13-vim"

docker_context=/root/shared/docker_context
cd ${docker_context}
echo ${docker_context}
unzip vim.zip -d vim
if [ $? != 0 ]; then
    echo "bad zip"
    exit 1
fi

pkgs="${pkgs} libncurses5-dev libgnome2-dev libgnomeui-dev \
      libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
      python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev"

apt-get install ${pkgs} -y

cd vim/vim-master
./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python3-config-dir=/usr/lib/python3.5/config \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr
make -j 8 && make install

curl http://j.mp/spf13-vim3 -L -o - | sh

echo "<<< installed spf13-vim"
