#!/usr/bin/env bash

apt-get update

pkgs="git wget curl make cmake apt-utils unzip tar"

apt-get install ${pkgs} -y

mkdir -p ${HOME}/github
git clone https://github.com/richard-tai/env.git ${HOME}/github/env
