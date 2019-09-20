#!/usr/bin/env bash

function download_vim() {
    echo "download vim"
    wget -O vim.zip -c -t 0 https://github.com/vim/vim/archive/master.zip
}

function check_zip() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    unzip -q $1 -d tmp
    return $?
}

if [ $# != 1 ]; then
    echo "$0 <name:tag>"
    exit 1
fi

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

docker build -t $1 .
