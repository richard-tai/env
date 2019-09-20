#!/usr/bin/env bash

apt-get update

pkgs="git wget curl make cmake apt-utils unzip"

apt-get install ${pkgs} -y

