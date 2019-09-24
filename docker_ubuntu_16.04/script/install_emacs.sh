#!/usr/bin/env bash

start_time=$(date +"%s")
echo "enter [$0]."

docker_context=/root/shared/docker_context
source ${docker_context}/util/utils.sh


echo "install rtags ..."
cd ${docker_context}/packages
#git clone --recursive https://github.com/Andersbakken/rtags.git rtags
cd rtags && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && make -j8 >/dev/null && make install
if [[ $? -ne 0 ]]; then
    echo "install rtags fail."
    exit 1
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."


echo "install bear ..."
cd ${docker_context}/packages
unzip_to_dir bear.zip Bear-master bear
cd bear && cmake . &&  make -j8 all >/dev/null && make install
if [[ $? -ne 0 ]]; then
    echo "install bear fail."
    exit 2
fi
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."


echo "build emacs ..."
cd ${docker_context}/packages
unzip -q emacs.zip -d emacs
if [ $? != 0 ]; then
    echo "bad zip"
    exit 1
fi
cd emacs/emacs-master
./autogen.sh >/dev/null
./configure --prefix=/usr --without-makeinfo --with-gnutls=no --without-x  >/dev/null
make -j8 >/dev/null && make install
if [[ $? -ne 0 ]]; then
    echo "install emacs fail."
    exit 2
fi
rm -rf emacs
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."



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
echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."

echo "install highlight ..."
cd ${docker_context}/packages
cp highlight.el ${HOME}/.emacs.d/

echo "install .emacs ..."
cd ${docker_context}
cp ubuntu/home/.emacs ${HOME}

echo "used $(($(date +"%s")-${start_time})) seconds in [$0]."
echo "leave [$0]."
