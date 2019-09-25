#!/usr/bin/env bash

start_time=$(date +"%s")

source util/utils.sh

work_dir=$(pwd)

if [[ ! -d ${work_dir}/packages ]]; then
    mkdir -p ${work_dir}/packages
fi

echo "download vim related packages..."
cd ${work_dir}/packages
wget_file_with_cache https://github.com/vim/vim/archive/master.zip vim.zip
wget_file_with_cache https://github.com/VundleVim/Vundle.vim/archive/master.zip Vundls.vim.zip # ${HOME}/.vim/bundle/Vundle.vim
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "download spf13-vim ..."
cd ${work_dir}/packages
if [[ ! -d spf13-vim ]]; then
    git clone https://github.com/spf13/spf13-vim.git spf13-vim # $HOME/.spf13-vim-3
else
    cd spf13-vim && git pull
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "download vundle ..."
cd ${work_dir}/packages
if [[ ! -d vundle ]]; then
    git clone https://github.com/gmarik/vundle.git vundle # $HOME/.vim/bundle/vundle
else
    cd vundle && git pull
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "download spf13-vim.sh ..."
cd ${work_dir}/packages
if [[ ! -f spf13-vim.sh ]]; then
    curl https://j.mp/spf13-vim3 -L > spf13-vim.sh
else
    echo "use existed."
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "download emacs related packages..."
cd ${work_dir}/packages
wget_file_with_cache https://github.com/emacs-mirror/emacs/archive/master.zip emacs.zip
wget_file_with_cache https://github.com/rizsotto/Bear/archive/master.zip bear.zip
wget_file_with_cache https://github.com/emacs-evil/goto-chg/archive/master.zip goto-chg.zip # ${HOME}/.emacs.d/goto-chg
wget_file_with_cache https://github.com/lukhas/buffer-move/archive/master.zip buffer-move.zip # ${HOME}/.emacs.d/buffer-move
wget_file_with_cache https://github.com/nschum/highlight-symbol.el/archive/master.zip highlight-symbol.zip # ${HOME}/.emacs.d/highlight-symbol
wget_file_with_cache https://github.com/jaypei/emacs-neotree/archive/dev.zip neotree.zip # ${HOME}/.emacs.d/neotree
wget_file_with_cache https://github.com/richard-tai/evil-search-highlight-persist/archive/master.zip evil-search-highlight-persist.zip # ${HOME}/.emacs.d/evil-search-highlight-persist

echo "download highlight ..."
cd ${work_dir}/packages
if [[ ! -d highlight ]]; then
    mkdir highlight
fi
if [[ ! -e highlight/highlight.el ]]; then
    wget_file_with_cache https://github.com/emacsmirror/emacswiki.org/raw/master/highlight.el highlight/highlight.el # ${HOME}/.emacs.d/highlight/
fi

echo "download undo-tree ..."
cd ${work_dir}/packages
if [[ ! -e undo-tree ]]; then
    git clone http://www.dr-qubit.org/git/undo-tree.git undo-tree # ${HOME}/.emacs.d/undo-tree
else
    cd undo-tree && git pull
fi

echo "download evil ..."
cd ${work_dir}/packages
if [[ ! -e evil ]]; then
git clone https://github.com/emacs-evil/evil evil # ${HOME}/.emacs.d/evil
else
    cd evil && git pull
fi

echo "download company ..."
cd ${work_dir}/packages
if [[ ! -e company ]]; then
    git clone https://github.com/company-mode/company-mode.git company
else
    cd company && git pull
fi

echo "download rtags ..."
cd ${work_dir}/packages
if [[ ! -d rtags ]]; then
    git clone --recursive https://github.com/Andersbakken/rtags.git rtags
else
    cd rtags && git pull
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."


echo "change apt source ..."
cd ${work_dir}
cp ubuntu/etc/apt/sources.list.16.04.local ubuntu/etc/apt/sources.list

echo "docker build ..."
cd ${work_dir}
docker build -t $1 .

echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
