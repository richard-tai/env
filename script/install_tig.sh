#!/bin/bash

# http://isay.me/2013/07/compile-install-tig.html

install_tig() {
    sudo dnf install -y ncurses-devel
    git clone https://github.com/jonas/tig.git ~/github/tig
    cd tig
    git checkout -t origin/release
    make configure
    ./configure --prefix=/usr
    make
    sudo make install install-release-doc
}


#################################

install_tig

