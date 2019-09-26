FROM ubuntu:16.04

ENV work_dir=/root/github/env/docker_ubuntu_16.04 \
    DEBIAN_FRONTEND=noninteractive

COPY . $work_dir

WORKDIR $work_dir

RUN bash script/install_prepare.sh
RUN bash script/install_vim.sh
RUN bash script/install_emacs.sh

CMD ["/bin/bash"]
