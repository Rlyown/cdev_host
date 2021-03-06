FROM ubuntu:20.04

ENV LANG=en_US.UTF-8
ENV TZ=Asia/Shanghai

WORKDIR /
ADD cgdb-0.7.1.tar.gz .

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update -y \
    && apt-get -y install gcc \
    gcc-multilib \
    g++ \
    gdb \
    nasm \
    automake \
    autoconf \
    libtool \
    make \
    cmake \
    ssh \
    ntp \
    vim \
    wget \
    curl \
    telnet \
    sudo \
    git \
    subversion \
    doxygen \
    lighttpd \
    net-tools \
    inetutils-ping \
    python \
    golang \
    libbz2-dev \
    libdb++-dev \
    libssl-dev \
    libdb-dev \
    libssl-dev \
    openssl \
    libreadline-dev \
    libcurl4-openssl-dev \
    libncurses-dev \
    autotools-dev \
    build-essential \
    libicu-dev \
    python-dev \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    grub2 \
    libgcc-9-dev \
    xorriso \
    texinfo \
    bison \
    flex \
    rsync \
    libboost-dev \
    libyaml-cpp-dev \
    parted \
    gdisk \
    udev \
    bear \
    meson \
    ninja-build\
    && apt clean \
    && mkdir /var/run/sshd \
    && echo "Port 36000" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && mkdir /home/bingo \
    && useradd -s /bin/bash bingo \
    && echo "bingo:123456" | chpasswd \
    && chown -R bingo:bingo /home/bingo \
    && echo "bingo  ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers \
    && sed -ri 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g' /etc/default/rsync


WORKDIR /cgdb-0.7.1/
RUN ./autogen.sh \
    && ./configure \
    && make -srj4 \
    && make install

WORKDIR /
RUN rm -rf cgdb-0.7.1 

# Container should expose ports.
EXPOSE 36000
CMD ["/usr/sbin/sshd", "-D"]
