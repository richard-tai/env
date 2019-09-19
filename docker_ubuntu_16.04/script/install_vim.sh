#!/usr/bin/env bash

echo "<<< to install spf13-vim"

git_dir="~/github/"
if [ ! -d ${git_dir} ]; then
        mkdir -p ${git_dir}
fi
cd ${git_dir}
git config --global http.postBuffer 524288000
git clone git://github.com/vim/vim.git
cd vim
./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python3-config-dir=/usr/lib/python3.5/config \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk2 --enable-cscope --prefix=/usr

cd ~/vim
make
make install

curl http://j.mp/spf13-vim3 -L -o - | sh

echo "<<< installed spf13-vim"
