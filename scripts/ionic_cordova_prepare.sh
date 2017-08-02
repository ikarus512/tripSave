#!/usr/bin/env bash

chmod +x hooks/after_prepare/010_add_platform_class.js

if [ ! -e platforms ];then

    ionic cordova prepare #--verbose

fi
