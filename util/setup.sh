#!/bin/bash

user=richard_tai
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

change_apt_source_18_04() {
	if [ ! -f /etc/apt/sources.list.backup ]; then
		cp /etc/apt/sources.list /etc/apt/sources.list.backup
	fi
	cp ${SHELL_FOLDER}/../ubuntu/etc/apt/sources.list.18.04.aliyun /etc/apt/sources.list
	apt-get update
}

install_vundle() {
	if [ ! -d  ${home}/.vim/bundle/ ]; then
		mkdir -p ${home}/.vim/bundle/
	fi
	git clone https://github.com/VundleVim/Vundle.vim.git ${home}/.vim/bundle/Vundle.vim
	chown -R ${user}:${user} ${home}/.vim
}

install_package() {
	#add-apt-repository ppa:jonathonf/vim -y
	#add-apt-repository ppa:openjdk-r/ppa -y
	#add-apt-repository ppa:apt-fast/stable -y
	#apt update

	install_vundle

	pkg_arr="ssh vim git python-dev git curl tree gcc g++ clang gdb cmake make screen tmux ctags cscope expect rsync openssl graphviz-dev libidn11-dev libcppunit-dev libcppunit-doc"
	for p in ${pkg_arr}; do
		echo ${p}
		apt-get install -y ${p};
	done

	# install java
	#sudo add-apt-repository ppa:webupd8team/java -y
	#sudo apt-get update
	#sudo apt-get install oracle-java8-installer
	#sudo apt-get install oracle-java8-set-default
}


copy_config() {
	if [ ! -f  ${home}/.tmux.conf ]; then
		cp ${SHELL_FOLDER}/../ubuntu/home/.vimrc ${home}
		cp ${SHELL_FOLDER}/../ubuntu/home/.tmux.conf ${home}
	fi
}

setup_ubuntu_18_04() {
	if [ "${issue}" != "18.04" ]; then
		return
	fi
	copy_config
	change_apt_source_18_04
	install_package
}

#################################

setup_ubuntu_18_04
