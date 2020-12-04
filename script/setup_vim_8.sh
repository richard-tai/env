#!/bin/bash

source utils.sh

# https://tpaschalis.github.io/vim-go-setup/

install_go() {
    echo "install golang.."
    sudo rm -rf /usr/local/bin/go /usr/bin/go
    sudo rm -rf /usr/local/bin/gofmt /usr/bin/gofmt
    if [ ! -f go1.14.linux-amd64.tar.gz ]; then
	wget -c -t 0 https://dl.google.com/go/go1.14.linux-amd64.tar.gz
    fi
    sudo tar -C /usr/local/ -xzf go1.14.linux-amd64.tar.gz
    sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

    #go env -w GOPROXY=https://goproxy.cn,direct

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

	sudo apt-get install -y ctags cscope make cmake curl

        if [ "${version:0:5}" == "20.04" ]; then
            # for ycm
            sudo apt-get install -y g++ python3-dev
        else
            # for ycm
            sudo apt-get install -y gcc-c++ python3-devel
        fi
	
	# for markdown preview
	sudo apt-get install -y nodejs npm yarn
    fi  
}

vim_root=~/.vim

install_gtags() {
    go_path=$(which global)
    if [ "$go_path" != "" ]; then
	return
    fi

    sudo ln -s /usr/bin/python3 /usr/bin/python
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    sudo ln -s /home/cat/.local/bin/pip /usr/bin/pip
    pip install pygments
    sudo apt install -y libncurses5-dev libncursesw5-dev clang make

    if [ ! -f global-6.6.5.tar.gz ]; then
	wget http://tamacom.com/global/global-6.6.5.tar.gz
    fi
    tar -xzf global-6.6.5.tar.gz
    cd global-6.6.5/
    ./configure && make && sudo make install
    cp gtags.vim ${vim_root}
    cd ..
}

install_vim_plugin() {
    
    echo "install_vim_plugin..."

    git clone --recursive https://github.com/richard-tai/.vim.git ${vim_root}

    if [ -d ${vim_root}/pack/plugins/start/vim-go ]; then
	    vim "+set nomore" "+GoInstallBinaries" "+qall"
    fi

    ycm_dir=${vim_root}/pack/plugins/start/YouCompleteMe
    if [ -d ${ycm_dir} ]; then
	ex_pwd=$(pwd)
	cd ${ycm_dir}
	#python3 install.py --clang-completer --go-completer
	cd ${ex_pwd}
    fi

    mkdp_dir=${vim_root}/pack/plugins/start/markdown-preview.nvim
    if [ -d ${mkdp_dir} ]; then
	source ~/.bashrc
	ex_pwd=$(pwd)
	cd ${mkdp_dir}/app
	bash install.sh
	cd ${ex_pwd}
    fi

    go get -u github.com/jstemmer/gotags

    install_gtags
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

