FROM ubuntu:16.04

ENV work_dir=/root/shared/docker_context \
    DEBIAN_FRONTEND=noninteractive

COPY . $work_dir

WORKDIR $work_dir

RUN bash script/install_prepare.sh
RUN bash script/install_vim.sh
RUN bash script/install_emacs.sh

CMD ["/bin/bash"]
