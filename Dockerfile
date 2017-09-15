FROM picoded/ubuntu-openjdk-8-jdk

MAINTAINER Vladislav Grishechko

RUN apt-get update && \
	apt-get install -y lib32stdc++6 lib32z1 git sudo

# Prepare to download and use Android SDK.

ENV ANDROID_SDK_FILE_NAME sdk-tools-linux-3859397.zip
ENV ANDROID_HOME /opt/sdk-tools-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

#Download Android SDK Components 

RUN mkdir -p $ANDROID_HOME && \
	curl https://dl.google.com/android/repository/$ANDROID_SDK_FILE_NAME --progress-bar --location --output $ANDROID_SDK_FILE_NAME && \
	unzip $ANDROID_SDK_FILE_NAME -d $ANDROID_HOME && \
	rm $ANDROID_SDK_FILE_NAME

ENV ANDROID_SDK_INSTALL_COMPONENT "echo \"y\" | \"$ANDROID_HOME\"/tools/bin/sdkmanager "

ENV ANDROID_SDK_COMPONENTS_REVISION 2017-09-05-14-10

RUN echo $ANDROID_SDK_COMPONENTS_REVISION && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "tools" "\"platform-tools\" \"build-tools;26.0.1\" \"platforms;android-26\" \"extras;google;m2repository\" \"extras;android;m2repository\""