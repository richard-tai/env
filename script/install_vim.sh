#!/usr/bin/env bash

source utils.sh

start_time=$(date +"%s")

if [[ ! -d ~/github/ ]]; then
    mkdir -p ~/github
fi

vim_name=v8.2.0348
wget_file_with_cache https://github.com/vim/vim/archive/${vim_name}.zip ~/github/vim.zip

cd ~/github/
unzip -q vim.zip -d vim
if [[ $? != 0 ]]; then
    echo "bad zip"
    exit 1
fi

cd vim/${vim_name}
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local
make -j4 VIMRUNTIMEDIR=/usr/local/share/vim/vim82
echo ${sudo_passwd} | sudo -S make install

echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
