#!/usr/bin/env bash

source utils.sh

start_time=$(date +"%s")

install_package libncurses5-dev libgnome2-dev libgnomeui-dev \
libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git

if [[ ! -d ~/github/ ]]; then
    mkdir -p ~/github
fi

vim_version=8.2.0348
wget_file_with_cache https://github.com/vim/vim/archive/v${vim_version}.zip ~/github/vim.zip

cd ~/github/
unzip -q vim.zip -d vim
if [[ $? != 0 ]]; then
    echo "bad zip"
    exit 1
fi

cd vim/vim-${vim_version}
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
