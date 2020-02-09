#!/bin/bash

# https://tpaschalis.github.io/vim-go-setup/

install_deps() {
    echo "install_deps..."
    sudo dnf install ctags cscope -y
    # for ycm
    sudo dnf install cmake gcc-c++ make python3-devel -y
}

install_vim_plugin() {
    echo "install_vim_plugin..."

    vim_go_dir=~/.vim/pack/plugins/start/vim-go
    if [ ! -d ${vim_go_dir}  ]; then
	git clone https://github.com/fatih/vim-go.git ${vim_go_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
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
	    echo "error, clone fail"
	    if [ ! -d ${nerdtree_dir} ]; then
		rm -r ${nerdtree_dir}
	    fi
	fi
    fi

    vim_airline_dir=~/.vim/pack/dist/start/vim-airline
    if [ ! -d ${vim_airline_dir}  ]; then
	git clone https://github.com/vim-airline/vim-airline  ${vim_airline_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${vim_airline_dir} ]; then
		rm -r ${vim_airline_dir}
	    fi
	fi
    fi

    vim_fugitive_dir=~/.vim/pack/dist/start/vim-fugitive
    if [ ! -d ${vim_fugitive_dir}  ]; then
	git clone https://github.com/tpope/vim-fugitive.git ${vim_fugitive_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${vim_fugitive_dir} ]; then
		rm -r ${vim_fugitive_dir}
	    fi
	fi
    fi

    tagbar_dir=~/.vim/pack/dist/start/tagbar
    if [ ! -d ${tagbar_dir}  ]; then
	git clone https://github.com/majutsushi/tagbar.git ${tagbar_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${tagbar_dir} ]; then
		rm -r ${tagbar_dir}
	    fi
	fi
    fi

    ctrlp_dir=~/.vim/pack/dist/start/ctrlp
    if [ ! -d ${ctrlp_dir}  ]; then
	git clone https://github.com/kien/ctrlp.vim.git ${ctrlp_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${ctrlp_dir} ]; then
		rm -r ${ctrlp_dir}
	    fi
	fi
    fi

    taglist_dir=~/.vim/pack/dist/start/taglist
    if [ ! -d ${taglist_dir}  ]; then
	git clone https://github.com/vim-scripts/taglist.vim.git ${taglist_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${taglist_dir} ]; then
		rm -r ${taglist_dir}
	    fi
	fi
    fi

    delimtMate_dir=~/.vim/pack/dist/start/delimitMate
    if [ ! -d ${delimtMate_dir}  ]; then
	git clone https://github.com/Raimondi/delimitMate.git ${delimtMate_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${delimtMate_dir} ]; then
		rm -r ${delimtMate_dir}
	    fi
	fi
    fi

    ycm_dir=~/.vim/pack/dist/start/YouCompleteMe
    if [ ! -d ${ycm_dir}  ]; then
	git clone --recurse-submodules https://github.com/ycm-core/YouCompleteMe.git ${ycm_dir}
	if [ $? -ne 0 ]; then
	    echo "error, clone fail"
	    if [ ! -d ${ycm_dir} ]; then
		rm -r ${ycm_dir}
	    fi
	else
	    ex_pwd=$(pwd)
	    cd ${ycm_dir}
	    python3 install.py --clang-completer --go-completer
	    cd ${ex_pwd}
	fi
    fi
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

