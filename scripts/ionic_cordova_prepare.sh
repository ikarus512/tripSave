#!/usr/bin/bash

if [ ! -e platforms ];then

    chmod +x hooks/after_prepare/010_add_platform_class.js
    ionic cordova prepare #--verbose

fi
