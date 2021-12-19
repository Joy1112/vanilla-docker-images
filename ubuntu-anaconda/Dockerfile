# basic image
FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

LABEL author = 'Joy' \
      description="This image is built from cuda:11.0.3-cudnn8-devel-ubuntu18.04, and basic required softwares (including Anaconda3, \
vim, wget, openssh-server, git, python3, libGL.so.1) are already installed."

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ARG DEBIAN_FRONTEND noninteractive
ARG USER="docker"
ARG PASSWD="docker"
ARG USER_HOME="/home/"$USER
EXPOSE 22

# copy files
COPY fixuid-*-linux-amd64.tar.gz /tmp/

# change time zone
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone

# install ca-certificates & update sources.list
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends apt-utils ca-certificates && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo -e "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n"\
"# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n"\
"deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n"\
"# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n"\
"deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n"\
"# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n"\
"deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n"\
"# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n"\
"\n"\
"# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse\n"\
"# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse" > /etc/apt/sources.list

# install basic softwares
RUN apt-get update --fix-missing && apt-get upgrade -y &&  \
    apt-get install -y --no-install-recommends sudo vim iproute2 wget curl iputils-ping net-tools iptables \
        graphviz openssh-server command-not-found git tzdata libgl1-mesa-glx python3 && \
    ln -s /usr/bin/python3.6 /usr/bin/python && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo 'sshd:ALL' >> /etc/hosts.allow && \
    dpkg-reconfigure tzdata && \
    apt-get autoclean && apt-get autoremove

# add new sudo user named docker with 'docker' as its password
RUN addgroup --gid 1111 docker && \
    adduser --uid 1111 --ingroup docker --home $USER_HOME --shell /bin/bash --disabled-password --gecos "" $USER && \
    adduser $USER sudo && \
    echo $USER:$PASSWD | chpasswd

# fixuid setup
RUN GROUP=docker && \
    mv /tmp/fixuid-*-linux-amd64.tar.gz /tmp/fixuid.tar.gz && \
    tar -C /usr/local/bin -xzf /tmp/fixuid.tar.gz && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# install anaconda3 & change conda/pip sources
RUN wget -q -P /tmp https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-2021.11-Linux-x86_64.sh && \
    mv /tmp/Anaconda3-*.sh /tmp/anaconda.sh && \
    /bin/bash /tmp/anaconda.sh -b -p /usr/local/anaconda3 && \
    groupadd anaconda && \
    usermod -a -G anaconda $USER && \
    chgrp -R anaconda /usr/local/anaconda3 && \
    chmod 777 -R /usr/local/anaconda3 && chmod g+s /usr/local/anaconda3 && chmod g+s `find /usr/local/anaconda3/ -type d`
ENV PATH /usr/local/anaconda3/bin:$PATH
RUN mkdir $USER_HOME/.pip && \
    echo -e "[global]\n"\
"index-url = https://pypi.tuna.tsinghua.edu.cn/simple\n"\
"\n"\
"[install]\n"\
"trusted-host = pypi.tuna.tsinghua.edu.cn" > $USER_HOME/.pip/pip.conf && \
    echo -e "channels:\n"\
"  - defaults\n"\
"show_channel_urls: true\n"\
"verify_ssl: false\n"\
"default_channels:\n"\
"  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n"\
"  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free\n"\
"  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r\n"\
"custom_channels:\n"\
"  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n"\
"  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n"\
"  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n"\
"  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n"\
"  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n"\
"  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" > $USER_HOME/.condarc && \
    echo -e "\n__conda_setup=\"\$('/usr/local/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)\"\n"\
"if [ \$? -eq 0 ]; then\n"\
"    eval \"\$__conda_setup\"\n"\
"else\n"\
"    if [ -f \"/usr/local/anaconda3/etc/profile.d/conda.sh\" ]; then\n"\
"        . \"/usr/local/anaconda3/etc/profile.d/conda.sh\"\n"\
"    else\n"\
"        export PATH=\"/usr/local/anaconda3/bin:\$PATH\"\n"\
"    fi\n"\
"fi\n"\
"unset __conda_setup\n" >> $USER_HOME/.bashrc && \
    source $USER_HOME/.bashrc && source /etc/profile && \
    chown -R $USER:docker $USER_HOME/

# create entrypoint start.sh
RUN echo -e '#!/bin/bash\n'\
'# UID/GID map to unknown user/group\n'\
'eval $( fixuid )\n'\
'# start ssh service\n'\
'echo '$PASSWD' | sudo -S service ssh start\n'\
'/bin/bash' > /home/start.sh && \
    chmod 777 /home/start.sh

# clean up
RUN	rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*

USER $USER:docker
ENTRYPOINT /home/start.sh
