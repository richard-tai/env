#!/usr/bin/env bash

function check_zip() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    unzip -q $1 -d tmp
    return $?
}

function check_tar_gz() {
    if [ -d tmp ]; then
        rm -rf tmp
    fi
    mkdir tmp
    tar -xzf  $1 -C tmp
    return $?
}

function wget_file_with_cache() {
    echo "wget [$1] to [$2]."
    extension=$(echo $1 | sed 's/^.*\.//')
    echo "file extension: [${extension}]."

    if [ "$extension" == "zip" ]; then
        check_zip $2
    elif [ "$extension" == "gz" ]; then
        check_tar_gz $2
    fi

    if [ $? != 0 ]; then
        echo "bad $2, wget again."
        wget -O $2 -c -t 0 $1
    else
        echo "use exist [$2]."
    fi

    if [ "$extension" == "zip" ]; then
        check_zip $2
    elif [ "$extension" == "gz" ]; then
        check_tar_gz $2
    fi

    if [ $? != 0 ]; then
        echo "bad $2, please check manually."
        return 2
    fi
}
