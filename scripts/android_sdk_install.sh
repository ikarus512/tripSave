#!/usr/bin/env bash

export ANDROID_HOME=$PWD/android-sdk-linux
export ANDROID_SDK=$ANDROID_HOME
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/23.0.2:${PATH}

if [ ! -e android-sdk-linux/tools/bin/sdkmanager ];then

    wget http://dl.google.com/android/android-sdk_r24.4-linux.tgz
    tar -xvf android-sdk_r24.4-linux.tgz

    android list sdk --extended # && android list sdk -a --extended

    ANDROPACKS=tools,platform-tools,build-tools-26.0.1,android-16,android-26
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -u -a -f -t ${ANDROPACKS}

    ### Accept licenses:
    # - mkdir $ANDROID_HOME/licenses
    # - echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
    # - echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

    # That requests us to accept a license for the sdkmanager, and then
    echo y | sdkmanager --update
    # requests us to accept new licenses not previously accepted
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | sdkmanager --licenses

fi
