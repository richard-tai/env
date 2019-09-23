#!/usr/bin/env bash

echo "install emacs ..."

docker_context=/root/shared/docker_context
source ${docker_context}/util/utils.sh

cd ${docker_context}/packages
echo "build emacs ..."
unzip -q emacs.zip -d emacs
if [ $? != 0 ]; then
    echo "bad zip"
    exit 1
fi
cd emacs/emacs-master
./autogen.sh
./configure --prefix=/usr --without-makeinfo --with-gnutls=no --without-x 
make -j 8 && make install
rm -rf emacs



cd ${docker_context}/packages
echo "install bear ..."
unzip_to_dir bear.zip Bear-master bear
cd bear && cmake . &&  make -j8 all && make install

echo "install rtags ..."
cd ${docker_context}/packages
unzip_to_dir rtags.zip rtags-master rtags
cd rtags && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && make -j8 && install

for one_pkg in  \
                goto-chg \
                buffer-move \
                evil-search-highlight-persist \
                highlight-symbol \
                neotree
do 
    echo "install ${one_pkg} ..."
    master_name=${one_pkg}-master
    if [ "${one_pkg}" == "highlight-symbol" ]; then
        master_name=${one_pkg}.el-master
    fi
    if [ "${one_pkg}" == "neotree" ]; then
        master_name=emacs-${one_pkg}-dev
    fi
    cd ${docker_context}/packages
    unzip_to_dir ${one_pkg}.zip ${master_name} ${HOME}/.emacs.d/${one_pkg}
done

echo "install highlight ..."
cd ${docker_context}/packages
cp highlight.el ${HOME}/.emacs.d/

echo "install .emacs ..."
cd ${docker_context}
cp ubuntu/home/.emacs ${HOME}


echo "installed emacs."
