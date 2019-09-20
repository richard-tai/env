#!/usr/bin/env bash

apt-get update

pkgs="git wget curl make cmake apt-utils unzip tar autoconf"

apt-get install ${pkgs} -y

git config --global http.postBuffer 1048576000

mkdir -p ${HOME}/github
git clone https://github.com/richard-tai/env.git ${HOME}/github/env
