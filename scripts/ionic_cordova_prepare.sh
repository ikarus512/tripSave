#!/usr/bin/env bash

chmod -R +x hooks
chmod -R +x scripts

if [ ! -e platforms ];then

    ionic cordova prepare || exit 1 #--verbose

fi
