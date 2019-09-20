#!/usr/bin/env bash

function download_vim() {
    echo "download vim"
    wget -O vim.zip -c -t 0 https://github.com/vim/vim/archive/master.zip
}

function download_emacs() {
    echo "download emacs"
    #wget -O emacs.tar.gz -c -t 0 https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-26.3.tar.gz
    wget -O emacs.zip -c -t 0 https://github.com/emacs-mirror/emacs/archive/master.zip
}

function check_zip() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    unzip -q $1 -d tmp
    return $?
}

function check_tar_gz() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    mkdir tmp
    tar -xzf  $1 -C tmp
    return $?
}

if [ $# != 1 ]; then
    echo "$0 <name:tag>"
    exit 1
fi

## download vim
if [ ! -f vim.zip ]; then
    download_vim
else
    check_zip vim.zip
    if [ $? != 0 ]; then
        echo "vim bad zip"
        download_vim
    fi
fi

check_zip vim.zip
if [ $? != 0 ]; then
    echo "vim bad zip"
    exit 2
fi

## download emacs
if [ ! -f emacs.zip ]; then
    download_emacs
else
    check_zip emacs.zip
    if [ $? != 0 ]; then
        echo "emacs bad zip"
        download_emacs
    fi
fi

check_zip emacs.zip
if [ $? != 0 ]; then
    echo "emacs bad zip"
    exit 3
fi


docker build -t $1 .
