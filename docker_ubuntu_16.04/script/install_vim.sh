#!/usr/bin/env bash

start_time=$(date +"%s")
echo "enter [$0]."

source util/utils.sh

echo "install vim ..."
cd ${docker_context}/packages
unzip -q vim.zip -d vim
if [[ $? != 0 ]]; then
    echo "bad zip"
    exit 1
fi
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
        --prefix=/usr >/dev/null
make -j8 >/dev/null && make install
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "install vundle ..."
cd ${docker_context}/packages
if [[ ! -e ${HOME}/.vim/bundle/xxx ]]; then
    mkdir -p ${HOME}/.vim/bundle/xxx
fi
rm -r ${HOME}/.vim/bundle/xxx
mv vundle ${HOME}/.vim/bundle/Vundle.vim

#echo "install spf13 ..."
#cd ${docker_context}/packages
#mv spf13-vim ${HOME}/.spf13-vim-3
#curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && 
#sh spf13-vim.sh

cd ${docker_context}
cp ubuntu/home/.vimrc ${HOME}
vim "+set nomore" "+BundleInstall!" "+BundleClean" "+qall"


echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
echo "leave [$0]."
