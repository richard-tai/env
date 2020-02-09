#!/bin/bash

# https://tpaschalis.github.io/vim-go-setup/

install_vim_plugin() {
    echo "install_vim_plugin..."

    vim_go_dir=~/.vim/pack/plugins/start/vim-go
    if [ ! -d ${vim_go_dir}  ]; then
	git clone https://github.com/fatih/vim-go.git ${vim_go_dir}
	if [ $? -ne 0 ]; then
	    echo "error, vim-go clone fail"
	    if [ ! -d ${vim_go_dir} ]; then
		rm -r ${vim_go_dir}
	    fi
	fi
    fi

    if [ -d ${vim_go_dir}  ]; then
	    vim "+set nomore" "+GoInstallBinaries" "+qall"
    fi

    nerdtree_dir=~/.vim/pack/dist/start/nerdtree
    if [ ! -d ${nerdtree_dir}  ]; then
	git clone https://github.com/scrooloose/nerdtree.git ${nerdtree_dir}
	if [ $? -ne 0 ]; then
	    echo "error, nerdtree clone fail"
	    if [ ! -d ${nerdtree_dir} ]; then
		rm -r ${nerdtree_dir}
	    fi
	fi
    fi

    vim_airline_dir=~/.vim/pack/dist/start/vim-airline
    if [ ! -d ${vim_airline_dir}  ]; then
	git clone https://github.com/vim-airline/vim-airline  ${vim_airline_dir}
	if [ $? -ne 0 ]; then
	    echo "error, vim-airline clone fail"
	    if [ ! -d ${vim_airline_dir} ]; then
		rm -r ${vim_airline_dir}
	    fi
	fi
    fi

    vim_fugitive_dir=~/.vim/pack/dist/start/vim-fugitive
    if [ ! -d ${vim_fugitive_dir}  ]; then
	git clone https://github.com/tpope/vim-fugitive.git ${vim_fugitive_dir}
	if [ $? -ne 0 ]; then
	    echo "error, vim-fugitive clone fail"
	    if [ ! -d ${vim_fugitive_dir} ]; then
		rm -r ${vim_fugitive_dir}
	    fi
	fi
    fi

    tagbar_dir=~/.vim/pack/dist/start/tagbar
    if [ ! -d ${tagbar_dir}  ]; then
	git clone https://github.com/majutsushi/tagbar.git ${tagbar_dir}
	if [ $? -ne 0 ]; then
	    echo "error, tagbar clone fail"
	    if [ ! -d ${tagbar_dir} ]; then
		rm -r ${tagbar_dir}
	    fi
	fi
    fi
}


copy_vim_config() {
    echo "copy_vim_config..."
    cp ../centos/home/.vimrc ~/
}

setup_vim() {
    copy_vim_config
    install_vim_plugin
}

#################################

setup_vim

