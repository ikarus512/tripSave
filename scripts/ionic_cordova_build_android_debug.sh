#!/usr/bin/env bash

myappname=tripSave

ionic cordova build android || exit 1 # --verbose

pushd platforms/android/build/outputs/apk || exit 1
    cp -frv android-armv7-debug.apk $myappname-debug.apk
    cp -frv android-x86-debug.apk   $myappname-debug-x86.apk
popd
