#!/bin/bash

install_vundle() {
	if [ ! -d  ${HOME}/.vim/bundle/ ]; then
		mkdir -p ${HOME}/.vim/bundle/
	fi
	git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
}

install_rtags() {
	git clone --recursive https://github.com/Andersbakken/rtags.git ${HOME}/.emacs.d/rtags
	cd ${HOME}/.emacs.d/rtags
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
	make
	sudo make install
}


install_bear() {
	git clone https://github.com/rizsotto/Bear.git ${HOME}/github/Bear
	cd  ${HOME}/github/Bear
	cmake .
	make all
	sudo make install
}

install_emacs_plugin() {
	git clone https://github.com/emacs-evil/goto-chg.git ${HOME}/.emacs.d/goto-chg
	git clone http://www.dr-qubit.org/git/undo-tree.git ${HOME}/.emacs.d/undo-tree
	git clone https://github.com/emacs-evil/evil ${HOME}/.emacs.d/evil
	git clone https://github.com/lukhas/buffer-move.git ${HOME}/.emacs.d/buffer-move
	git clone https://github.com/nschum/highlight-symbol.el.git ${HOME}/.emacs.d/highlight-symbol
	git clone https://github.com/jaypei/emacs-neotree.git ${HOME}/.emacs.d/neotree
    git clone https://github.com/richard-tai/evil-search-highlight-persist.git ${HOME}/.emacs.d/evil-search-highlight-persist
	mkdir ${HOME}/.emacs.d/highlight
	wget https://github.com/emacsmirror/emacswiki.org/raw/master/highlight.el ${HOME}/.emacs.d/highlight/
}


install_package() {
	#add-apt-repository ppa:jonathonf/vim -y
	#add-apt-repository ppa:openjdk-r/ppa -y
	#add-apt-repository ppa:apt-fast/stable -y
	#apt update

	install_vundle

	pkg_arr="ssh vim emacs git python-dev git curl tree gcc g++ clang gdb cmake make screen tmux \
			ctags cscope expect rsync openssl graphviz graphviz-dev libidn11-dev libcppunit-dev \
			libcppunit-doc dos2unix apache2 xrdp python-pycurl libcurl4-gnutls-dev ant \
			net-tools libssl-dev clang libclang-dev autoconf zlib1g-dev libbz2-dev pstack \
			openjdk-8-jdk libqt4-dev libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev \
			libswscale-dev libjpeg-dev libpng-dev libtiff-dev libopenblas-base libsdl2-dev libsdl2-image-dev \
			libdc1394-22-dev cmake-qt-gui libgnutls-dev libtiff5-dev libgif-dev libxpm-dev libncurses5-dev"
	for p in ${pkg_arr}; do
		echo ${p}
		sudo apt-get install -y ${p};
	done

	pip_pkg_arr="mysql-python"
	for p in ${pip_pkg_arr}; do
		echo ${p}
		pip install ${p};
	done

	install_emacs_plugin
	install_rtags
	install_bear
	

	# install java, manully confirmation needed
	#sudo add-apt-repository ppa:webupd8team/java -y
	#sudo apt-get update
	#sudo apt-get install oracle-java8-installer
	#sudo apt-get install oracle-java8-set-default

}

make_dirs() {
	dirs="${HOME}/github"
	for d in ${dirs}; do
		if [ ! -d ${d} ]; then
			mkdir -p ${d}
			echo make dir ${d}
		fi
	done
}

copy_config() {
	if [ ! -f  ${HOME}/.tmux.conf ]; then
		cp ${HOME}/github/env/ubuntu/home/.vimrc ${HOME}
		cp ${HOME}/github/env/ubuntu/ubuntu/home/.tmux.conf ${HOME}
		cp ${HOME}/github/env/ubuntu/ubuntu/home/.emacs ${HOME}
	fi
}
