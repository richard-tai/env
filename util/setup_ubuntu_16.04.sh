#!/bin/bash

user=elephant
if [ $# -ge 1 ]; then
	user=$1
fi

home=/home/${user}
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

issue=$(cat /etc/issue | cut -d ' ' -f 2)

echo home: ${home}
echo SHELL_FOLDER: ${SHELL_FOLDER}
echo issue: ${issue}

#exit

change_apt_source_16_04() {
	if [ ! -f /etc/apt/sources.list.backup ]; then
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
	fi
	sudo cp ${SHELL_FOLDER}/../ubuntu/etc/apt/sources.list.16.04.aliyun /etc/apt/sources.list
	sudo apt-get update
}

install_vundle() {
	if [ ! -d  ${home}/.vim/bundle/ ]; then
		mkdir -p ${home}/.vim/bundle/
	fi
	git clone https://github.com/VundleVim/Vundle.vim.git ${home}/.vim/bundle/Vundle.vim
	chown -R ${user}:${user} ${home}/.vim
}

install_rtags() {
	git clone --recursive https://github.com/Andersbakken/rtags.git ${home}/.emacs.d/rtags
	cd ${home}/.emacs.d/rtags
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
	make
	sudo make install
}

install_neotree() {
	git clone https://github.com/jaypei/emacs-neotree.git ${home}/.emacs.d/neotree
}

install_bear() {
	git clone https://github.com/rizsotto/Bear.git ${home}/github/Bear
	cd  ${home}/github/Bear
	cmake .
	make all
	sudo make install
}

install_evil() {
	git clone https://github.com/emacs-evil/goto-chg.git ${home}/.emacs.d/goto-chg
	git clone http://www.dr-qubit.org/git/undo-tree.git ${home}/.emacs.d/undo-tree
	git clone https://github.com/emacs-evil/evil ${home}/.emacs.d/evil
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

	install_neotree
	install_evil
	install_rtags
	install_bear

	# install java, manully confirmation needed
	#sudo add-apt-repository ppa:webupd8team/java -y
	#sudo apt-get update
	#sudo apt-get install oracle-java8-installer
	#sudo apt-get install oracle-java8-set-default

}

make_dirs() {
	dirs="${home}/github"
	for d in ${dirs}; do
		if [ ! -d ${d} ]; then
			mkdir -p ${d}
			echo make dir ${d}
		fi
	done
}

copy_config() {
	if [ ! -f  ${home}/.tmux.conf ]; then
		cp ${SHELL_FOLDER}/../ubuntu/home/.vimrc ${home}
		cp ${SHELL_FOLDER}/../ubuntu/home/.tmux.conf ${home}
		cp ${SHELL_FOLDER}/../ubuntu/home/.emacs ${home}
	fi
}

setup_ubuntu_16_04() {
	if [ "${issue:0:5}" != "16.04" ]; then
		echo "OS version not match"
		return
	fi
	make_dirs
	copy_config
	change_apt_source_16_04
	install_package
}

#################################

setup_ubuntu_16_04