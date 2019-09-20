FROM ubuntu:16.04

ENV work_dir=/root/shared/docker_context

COPY ./ubuntu/etc/apt/sources.list.16.04.aliyun /etc/apt/
COPY . $work_dir

WORKDIR $work_dir

RUN bash script/install_prepare.sh
#RUN bash script/install_vim.sh
RUN bash script/install_emacs.sh
RUN bash script/install_more.sh

CMD ["/bin/bash"]
