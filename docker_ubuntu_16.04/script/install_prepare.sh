#!/usr/bin/env bash

docker_context=/root/shared/docker_context

# set apt
echo "
192.30.253.120  codeload.github.com
140.82.114.3    github.com
185.199.111.153 assets-cdn.github.com
199.232.5.194   github.global.ssl.fastly.net
" >> /etc/hosts
/etc/init.d/networking restart

cp ${docker_context}/ubuntu/etc/apt/sources.list /etc/apt/sources.list

apt-get update

pkgs="git wget curl make cmake apt-utils unzip tar autoconf"

apt-get install ${pkgs} -y

git config --global http.postBuffer 1048576000

mkdir -p ${HOME}/github
