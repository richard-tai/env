#!/usr/bin/env bash

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

## unit test
#echo $(get_file_extenstion aa.bb.cc.tar)
#echo $(get_file_name aa.bb.cc.tar)
