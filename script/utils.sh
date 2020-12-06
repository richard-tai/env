#!/usr/bin/env bash

#set -o nounset    # error when referencing undefined variable
#set -o errexit    # exit when command fails

BOLD="$(tput bold 2>/dev/null || echo '')"
GREY="$(tput setaf 0 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
NO_COLOR="$(tput sgr0 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"

error() {
  printf "${RED} $@${NO_COLOR}\n" >&2
}

warn() {
  printf "${YELLOW}! $@${NO_COLOR}\n"
}

info() {
  printf "${BLUE} $@${NO_COLOR}\n"
}

## global variable
g_os_name=""
g_os_version=""


function get_os_version()
{
	if [ "${g_os_version}" != "" ]; then
		echo ${g_os_version}
		return 0
	fi

    if [ -f /etc/issue ]; then
		g_os_version=$(cat /etc/issue | head -n 1 | awk '{ print $2 }')
		echo ${g_os_version}
        return 0
    fi  

    if [ -f /etc/redhat-release ]; then
        g_os_version=$(cat /etc/redhat-release | head -n 1 | awk '{ print $4 }')
		echo ${g_os_version}
        return 0
    fi  

    echo "Unknown"
}

function get_os_name()
{
	if [ "${g_os_name}" != "" ]; then
		echo ${g_os_name}
		return 0
	fi

    if [ -f /etc/issue ]; then
        g_os_name=$(cat /etc/issue | head -n 1 | awk '{ print $1}')
		echo ${g_os_name}
        return 0
    fi  

    if [ -f /etc/redhat-release ]; then
        g_os_name=$(cat /etc/redhat-release | head -n 1 | awk '{ print $1 }')
		echo ${g_os_name}
        return 0
    fi  

    echo "Unkown"
}


function get_file_extenstion()
{
    echo $(echo $1 | sed 's/^.*\.//')
}

function get_file_name()
{
    echo $(echo $1 | sed 's/\.[^.]*$//')
}

function check_zip() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    unzip -q $1 -d tmp
    ret=$?
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    return ${ret}
}

function check_tar_gz() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    mkdir tmp
    tar -xzf  $1 -C tmp
    ret=$?
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    return ${ret}
}

function wget_file_with_cache() {
    echo "wget [$1] to [$2]."
    extension=$(get_file_extenstion $1)
    echo "file extension: [${extension}]."

    if [ -f $2 ]; then
        if [ "$extension" == "zip" ]; then
            check_zip $2
        elif [ "$extension" == "gz" ]; then
            check_tar_gz $2
        fi

        if [ $? -eq 0 ]; then
            echo "use exist [$2]."
            return 0
        fi
    fi

    wget -O $2 -c -t 0 $1

    if [ "$extension" == "zip" ]; then
        check_zip $2
    elif [ "$extension" == "gz" ]; then
        check_tar_gz $2
    fi

    if [ $? -ne 0 ]; then
        echo "bad $2, please check manually."
        return 2
    fi
}

function unzip_to_dir() {
    zip_path=$1
    raw_name=$2
    dest_name=$3
    echo "unzip [${zip_path}] to [${raw_name}], rename to [${dest_name}]"

    if [ ! -d ${dest_name} ]; then
        mkdir -p ${dest_name}
    fi

    for one_dir in tmp ${dest_name}
    do
        if [ -d "${one_dir}" ]; then
            rm -rf ${one_dir}
        fi
    done

    unzip -q ${zip_path} -d tmp
    mv tmp/${raw_name} ${dest_name}

    if [ -d tmp ]; then
        rm -rf tmp
    fi
}

function install_package() {
	os_name=$(get_os_name)
	for one in $1; do
		if hash $one 2>/dev/null; then
			warn "$one installed before"
			continue
		fi
		info "Installing $one ..."
		if [ "$os_name" == "Ubuntu" ]; then
			sudo apt install -y $one
		elif [ "$os_name" == "Centos" ]; then
			sudo yum install -y $one
		fi
		info "Install $one done"

		if [ "$one" == "git" ]; then
			git config --global http.postBuffer 1048576000
		else
			continue
		fi
		info "config $one done"
	done
}

function support_python3() {
	if hash python 2>/dev/null; then
		output_str=$(python --version)
		if [ "${output_str:0:8}" == "Python 3" ]; then
			return 0
		fi
	
	fi
	return 1
}

## unit test
#echo $(get_file_extenstion aa.bb.cc.tar)
#echo $(get_file_name aa.bb.cc.tar)
#install_package "tree git xxx vim"

if ! hash xtig 2>/dev/null; then
	echo "xxxxxxxxxxxxxxxxxxxxx"
fi

