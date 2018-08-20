FROM ubuntu:16.04

MAINTAINER Dmitry Prokhorov <dipspb@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

LABEL version="1.0.0"

RUN apt-get update && \
	apt-get install -y --show-progress --no-install-recommends \
        curl \
        zip unzip \
        sudo \
        gnupg \
        libstdc++6 libgcc1 zlib1g libncurses5 \
        default-jdk \
        git \
        make \
        build-essential \
        python-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

RUN apt-get update && \
	apt-get install -y --show-progress --no-install-recommends \
        nodejs

RUN npm install npm --global

# Install 32bit support for Android SDK
RUN dpkg --add-architecture i386 && \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386

ENV ANDROID_SDK_FILE tools_r25.2.5-macosx.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/$ANDROID_SDK_FILE

## Install Android SDK
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN cd /usr/local && \
    mkdir -p $ANDROID_HOME && \
    cd $ANDROID_HOME && \
    curl $ANDROID_SDK_URL --output $ANDROID_SDK_FILE && \
    unzip $ANDROID_SDK_FILE && \
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools && \
    chgrp -R users $ANDROID_HOME && \
    chmod -R 0775 $ANDROID_HOME && \
    rm $ANDROID_SDK_FILE

ARG ANDROID_SDK_VERSION=26
ARG ANDROID_BUILD_TOOLS_VERSION=26.0.2

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION

RUN (while sleep 3; do echo "y"; done) | android update sdk \
    --no-ui \
    --force \
    --all \
    --filter platform-tools,android-$ANDROID_SDK_VERSION,build-tools-$ANDROID_BUILD_TOOLS_VERSION,extra-android-support,extra-android-m2repository,sys-img-x86_64-android-$ANDROID_SDK_VERSION,extra-google-m2repository


RUN npm install -g react-native-cli@2.0.1 create-react-native-app node-gyp

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    npm cache clear --force

EXPOSE 8081

# ENV USERNAME dev

# RUN adduser --disabled-password --gecos '' $USERNAME && \
#     echo $USERNAME:$USERNAME | chpasswd && \
#     echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
#     adduser $USERNAME sudo

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# USER $USERNAME
USER root

# WORKDIR /home/$USERNAME
WORKDIR /root

# ENV GRADLE_USER_HOME /home/$USERNAME/app/android/gradle_deps
ENV GRADLE_USER_HOME /root/app/android/gradle_deps

ENTRYPOINT ["/tini", "--"]

