FROM ubuntu:18.04

MAINTAINER Angelo DErrico

# ENV DEBIAN_FRONTEND = noninteractive

RUN mkdir -p /app
RUN mkdir -p /development/android-sdk

# RUN cd /development

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y unzip curl gnupg software-properties-common

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential

RUN npm install -g react-native-cli

RUN apt-get install -y gcc g++ make
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -y oracle-java8-installer

RUN wget -O /development/android-sdk/sdk-tools-linux-4333796.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip development/android-sdk/sdk-tools-linux-4333796.zip -d /development/android-sdk

ENV ANDROID_API_LEVELS android-26
ENV ANDROID_BUILD_TOOLS_VERSION 26.0.3
ENV ANDROID_HOME /development/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

RUN mkdir -p $ANDROID_HOME/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license
RUN echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license

RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools"
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
RUN $ANDROID_HOME/tools/bin/sdkmanager "platforms;${ANDROID_API_LEVELS}"

RUN cd /app
WORKDIR /app
