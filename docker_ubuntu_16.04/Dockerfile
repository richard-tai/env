FROM ubuntu:16.04

COPY ./ubuntu/etc/apt/sources.list.16.04.aliyun /etc/apt/
COPY ./script/* /shared/script/

WORKDIR /shared/script/

RUN bash /shared/script/install_prepare.sh
RUN bash /shared/script/install_vim.sh
RUN bash /shared/script/install_more.sh

CMD ["/bin/bash"]
