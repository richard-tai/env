#!/bin/bash

source setup_common.sh

user=cat
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
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
	fi
	sudo cp ${SHELL_FOLDER}/../ubuntu/etc/apt/sources.list.18.04.aliyun /etc/apt/sources.list
	sudo apt-get update
}

setup_ubuntu_18_04() {
	if [ "${issue:0:5}" != "18.04" ]; then
		echo "OS version not match"
		return
	fi
	make_dirs
	copy_config
	change_apt_source_18_04
	install_package
}

#################################

setup_ubuntu_18_04
