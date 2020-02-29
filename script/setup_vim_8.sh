#!/bin/bash

# https://tpaschalis.github.io/vim-go-setup/

install_go() {
    echo "install golang.."
    sudo rm -rf /usr/local/go /usr/bin/go
    wget -c -t 0 https://studygolang.com/dl/golang/go1.14.linux-amd64.tar.gz
    sudo tar -C /usr/local/ -xzf go1.14.linux-amd64.tar.gz

    # echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    
}

install_deps() {
    echo "install_deps..."
    install_go
    sudo dnf install ctags cscope -y
    # for ycm
    sudo dnf install cmake gcc-c++ make python3-devel -y
}

install_vim_plugin() {
    
    echo "install_vim_plugin..."

    vim_root=~/.vim

    git clone --recursive https://github.com/richard-tai/.vim.git ${vim_root}

    if [ -d ${vim_root}/pack/plugins/start/vim-go ]; then
	    vim "+set nomore" "+GoInstallBinaries" "+qall"
    fi

    ycm_dir=${vim_root}/pack/plugins/start/YouCompleteMe
    if [ ! -d ${ycm_dir} ]; then
	ex_pwd=$(pwd)
	cd ${ycm_dir}
	python3 install.py --clang-completer --go-completer
	cd ${ex_pwd}
    fi
}


copy_vim_config() {
    echo "copy_vim_config..."
    cp ../centos/home/.vimrc ~/
}

setup_vim() {
    #install_deps
    copy_vim_config
    install_vim_plugin
}

#################################

setup_vim

