FROM openjdk:8-jdk

MAINTAINER mobile-onliner

RUN apt-get update && \
	apt-get install -y lib32stdc++6 lib32z1 git sudo

# Prepare to download and use Android SDK.

ENV ANDROID_SDK_FILE_NAME sdk-tools-linux-3859397.zip
ENV ANDROID_HOME /opt/sdk-tools-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

#Make project directory
RUN mkdir /opt/project

#Download Android SDK Components
RUN mkdir -p $ANDROID_HOME && \
	curl https://dl.google.com/android/repository/$ANDROID_SDK_FILE_NAME --progress-bar --location --output $ANDROID_SDK_FILE_NAME && \
	unzip $ANDROID_SDK_FILE_NAME -d $ANDROID_HOME && \
	rm $ANDROID_SDK_FILE_NAME

ENV ANDROID_SDK_INSTALL_COMPONENT "echo \"y\" | \"$ANDROID_HOME\"/tools/bin/sdkmanager "

ENV ANDROID_SDK_COMPONENTS_REVISION 2018-01-05-17-11

RUN echo $ANDROID_SDK_COMPONENTS_REVISION && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "tools" && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "build-tools\;27.0.2" && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "platforms\;android-27" && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "extras\;google\;m2repository" && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "extras\;android\;m2repository" && \
	eval $ANDROID_SDK_INSTALL_COMPONENT "system-images\;android-27\;google_apis_playstore\;x86"

COPY . /opt/cache/

RUN cd /opt/cache/ && \
    ls && \
    ./gradlew clean testQa assembleQa && \
    rm -rf /opt/cache
