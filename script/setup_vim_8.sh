#!/usr/bin/env bash

source utils.sh

# https://tpaschalis.github.io/vim-go-setup/

install_go() {
    go_version="go1.21.9"
    info "Installing golang $go_verson ..."

    if hash go 2>/dev/null; then
	warn "go installed before"
	go version
	return
    fi

    sudo rm -rf /usr/local/bin/go /usr/bin/go
    sudo rm -rf /usr/local/bin/gofmt /usr/bin/gofmt
    if [ ! -f ${go_version}.linux-amd64.tar.gz ]; then
	wget -c -t 0  https://golang.google.cn/dl/${go_version}.linux-amd64.tar.gz
    fi
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local/ -xzf ${go_version}.linux-amd64.tar.gz
    sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
    sudo chmod 777 -R /usr/local/go

    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.cn,direct
    go env -w GOBIN=/usr/local/go/bin

    if path_contain /usr/local/go/bin; then
	info  "PATH already exist!"
    else
	echo 'PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
	source ~/.bashrc
    fi

    if ! hash go 2>/dev/null; then
	warn "go install failed"
	exit 1
    fi
    go version
}

install_go_tool() {
     #gopath=~/go
    #git clone https://github.com/golang/tools.git ${gopath}/src/golang.org/x/tools
    #git clone https://github.com/golang/lint.git ${gopath}/src/golang.org/x/lint
    #git clone https://github.com/golang/mod.git ${gopath}/src/golang.org/x/mod
    #git clone https://github.com/golang/xerrors.git ${gopath}/src/golang.org/x/xerrors
    #git clone https://github.com/golang/net.git ${gopath}/src/golang.org/x/net

    #echo "install go tool..."
    #cd $gopath
    go install golang.org/x/lint/golint@latest
    #echo "golint installed"
    go install golang.org/x/tools/cmd/gorename@latest
    #echo "gorename installed"
    go install golang.org/x/tools/cmd/godoc@latest
    #echo "godoc installed"
    go install golang.org/x/tools/cmd/guru@latest
    #echo "guru installed"
}

install_deps() {
    echo -- [$g_os_name] [$g_os_version] ----------------------------
    install_go
    install_package tree curl wget
    install_package ctags cscope 
    install_package make cmake clang g++ gcc-c++
    install_package python3 python3-dev python3-devel
    install_package nodejs npm yarn
}

vim_root=~/.vim

install_gtags() {
    info "Installing gtags ..."
    if hash global 2>/dev/null; then
	warn "global installed before"
	return
    fi

    if ! hash pip 2>/dev/null; then
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	python get-pip.py
	sudo ln -s /home/cat/.local/bin/pip /usr/bin/pip
    fi
    pip install pygments

    install_package libncurses5-dev libncursesw5-dev clang make

    if [ ! -f global-6.6.5.tar.gz ]; then
	wget http://tamacom.com/global/global-6.6.5.tar.gz
    fi
    tar -xzf global-6.6.5.tar.gz
    cd global-6.6.5/
    ./configure && make && sudo make install
    cp gtags.vim ${vim_root}
    cd ..
    info "Install gtags done"
}

install_vim_plugin() {
    echo "Installing vim plugins ..."

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

    mkdp_dir=${vim_root}/pack/plugins/start/markdown-preview.nvim
    if [ -d ${mkdp_dir} ]; then
	source ~/.bashrc
	ex_pwd=$(pwd)
	cd ${mkdp_dir}/app
	bash install.sh
	cd ${ex_pwd}
    fi

    go install github.com/jstemmer/gotags@latest

    install_gtags

    echo "Install vim plugins done" 
}


copy_vim_config() {
    echo "copy_vim_config..."
    cp ../conf/centos/home/.vimrc ~/
    cp ../conf/centos/home/.tmux.conf ~/
}

setup_vim() {
    install_deps
    copy_vim_config
    install_vim_plugin
}

main() {
    if !support_python3; then
	error "python3 not found or not default verison"
	return 1
    fi

    setup_vim
}

#################################

#setup_vim
install_go
#install_gtags
#install_vim_plugin
#copy_vim_config
#main

