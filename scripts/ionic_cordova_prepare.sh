#!/usr/bin/env bash

chmod -R +x hooks
chmod -R +x scripts

if [ ! -e platforms/android ];then

    ionic cordova prepare || exit 1
    # ionic cordova prepare --verbose || exit 1

    ionic cordova platform add android || exit 1

fi
