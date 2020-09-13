#!/bin/bash

source utils.sh

# https://tpaschalis.github.io/vim-go-setup/

install_go() {
    echo "install golang.."
    sudo rm -rf /usr/local/go /usr/bin/go
	if [ ! -f go1.14.linux-amd64.tar.gz ]; then
		wget -c -t 0 https://dl.google.com/go/go1.14.linux-amd64.tar.gz
	fi
    sudo tar -C /usr/local/ -xzf go1.14.linux-amd64.tar.gz
    go_path=$(which go)
    if [ "$go_path" != "/usr/local/go/bin/go" ]; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        source ~/.bashrc
    fi  

    go env -w GOPROXY=https://goproxy.cn,direct

    #gopath=~/go
    #git clone https://github.com/golang/tools.git ${gopath}/src/golang.org/x/tools
    #git clone https://github.com/golang/lint.git ${gopath}/src/golang.org/x/lint
    #git clone https://github.com/golang/mod.git ${gopath}/src/golang.org/x/mod
    #git clone https://github.com/golang/xerrors.git ${gopath}/src/golang.org/x/xerrors
    #git clone https://github.com/golang/net.git ${gopath}/src/golang.org/x/net

    #echo "install go tool..."
    #cd $gopath
    #go install golang.org/x/lint/golint
    #echo "golint installed"
    #go install golang.org/x/tools/cmd/gorename
    #echo "gorename installed"
    #go install golang.org/x/tools/cmd/godoc
    #echo "godoc installed"
    #go install golang.org/x/tools/cmd/guru
    #echo "guru installed"
}

install_deps() {
    echo "install_deps..."
    install_go
    os=$(get_os_name)
    version=$(get_os_version)
    echo [$os] [$version] ----------------------------

    if [ $os == "Ubuntu" ]; then
	sudo apt-get update

        if [ "${version:0:5}" == "20.04" ]; then
            sudo apt-get install -y ctags cscope
            # for ycm
            sudo apt-get install -y cmake g++ make python3-dev
        else
            sudo apt-get install -y ctags cscope
            # for ycm
            sudo apt-get install -y cmake gcc-c++ make python3-devel
        fi
    fi  

    if [ $os == "CentOS" ]; then
        sudo dnf install ctags cscope -y
        # for ycm
        sudo dnf install cmake gcc-c++ make python3-devel -y
    fi  

}

install_vim_plugin() {
    
    echo "install_vim_plugin..."

    vim_root=~/.vim

    git clone --recursive https://github.com/richard-tai/.vim.git ${vim_root}

    if [ -d ${vim_root}/pack/plugins/start/vim-go ]; then
	    vim "+set nomore" "+GoInstallBinaries" "+qall"
    fi

    ycm_dir=${vim_root}/pack/plugins/start/YouCompleteMe
    if [ -d ${ycm_dir} ]; then
	ex_pwd=$(pwd)
	cd ${ycm_dir}
	python3 install.py --clang-completer --go-completer
	cd ${ex_pwd}
    fi

    mkdp_dir=${vim_root}/pack/plugins/start/markdown-preview.nvm
    if [ -d ${mkdp_dir} ]; then
	ex_pwd=$(pwd)
	cd ${mkdp_dir}/app
	bash install.sh
	cd ${ex_pwd}
    fi

	go get -u github.com/jstemmer/gotags
}


copy_vim_config() {
    echo "copy_vim_config..."
    cp ../centos/home/.vimrc ~/
}

setup_vim() {
    install_deps
    copy_vim_config
    install_vim_plugin
}

#################################

setup_vim
#install_go

