# basic image
FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

LABEL author = 'Joy' \
      description="This image is built from cuda:11.0.3-cudnn8-devel-ubuntu18.04, and basic required softwares (including Anaconda3, \
vim, wget, openssh-server, git, python3, libGL.so.1) are already installed."

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 22

# copy files
COPY Anaconda3-*.sh files /tmp/

# change time zone
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone

# install ca-certificates & update sources.list
RUN apt-get update --fix-missing && \
    apt-get install ca-certificates && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    mv /tmp/sources.list /etc/apt/sources.list

# install basic softwares
RUN apt-get update --fix-missing && apt-get upgrade -y &&  \
    apt-get install -y --no-install-recommends apt-utils sudo vim iproute2 wget graphviz openssh-server git tzdata libgl1-mesa-glx && \
    apt-get install -y --no-install-recommends python3 && ln -s /usr/bin/python3.6 /usr/bin/python && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo 'sshd:ALL' >> /etc/hosts.allow && \
    dpkg-reconfigure tzdata && \
    apt-get autoclean && apt-get autoremove

# install anaconda3 & change conda/pip sources
RUN mv /tmp/Anaconda3-*.sh /tmp/anaconda.sh && /bin/bash /tmp/anaconda.sh -b -p /root/anaconda3 && rm /tmp/anaconda.sh
ENV PATH /root/anaconda3/bin:$PATH
RUN mkdir /root/.pip && \
    mv /tmp/pip.conf /root/.pip/ && \
    mv /tmp/condarc /root/.condarc && \
    cat /tmp/conda_init >> /root/.bashrc && source /root/.bashrc && source /etc/profile

# remove tmp files
RUN	rm -rf /tmp/* /var/cache/* /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/*
