#!/usr/bin/env bash

source util/utils.sh

if [ ! -d packages ]; then
    mkdir packages
fi

echo "download vim related packages..."
wget_file_with_cache https://github.com/vim/vim/archive/master.zip packages/vim.zip
wget_file_with_cache https://github.com/VundleVim/Vundle.vim/archive/master.zip packages/Vundls.vim.zip # ${HOME}/.vim/bundle/Vundle.vim


echo "download emacs related packages..."
wget_file_with_cache https://github.com/emacs-mirror/emacs/archive/master.zip packages/emacs.zip

wget_file_with_cache https://github.com/rizsotto/Bear/archive/master.zip packages/bear.zip

wget_file_with_cache https://github.com/emacs-evil/goto-chg/archive/master.zip packages/goto-chg.zip # ${HOME}/.emacs.d/goto-chg

wget_file_with_cache https://github.com/lukhas/buffer-move/archive/master.zip packages/buffer-move.zip # ${HOME}/.emacs.d/buffer-move

wget_file_with_cache https://github.com/nschum/highlight-symbol.el/archive/master.zip packages/highlight-symbol.zip # ${HOME}/.emacs.d/highlight-symbol

wget_file_with_cache https://github.com/jaypei/emacs-neotree/archive/dev.zip packages/neotree.zip # ${HOME}/.emacs.d/neotree

wget_file_with_cache https://github.com/richard-tai/evil-search-highlight-persist/archive/master.zip packages/evil-search-highlight-persist.zip # ${HOME}/.emacs.d/evil-search-highlight-persist

wget_file_with_cache https://github.com/emacsmirror/emacswiki.org/raw/master/highlight.el packages/highlight.el # ${HOME}/.emacs.d/highlight/


echo "change apt source"
cp ubuntu/etc/apt/sources.list.16.04.local ubuntu/etc/apt/sources.list


echo "docker build ..."
docker build -t $1 .
