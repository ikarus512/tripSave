#!/usr/bin/env bash

myappname=tripSave

ionic cordova build android || exit 1 # --verbose

cp -frv platforms/android/build/outputs/apk/android-armv7-debug.apk releases/$myappname-debug.apk
cp -frv platforms/android/build/outputs/apk/android-x86-debug.apk   releases/$myappname-debug-x86.apk
rm -fv  platforms/android/build/outputs/apk/*debug*.apk
