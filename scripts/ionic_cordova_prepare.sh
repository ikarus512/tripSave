#!/usr/bin/env bash

chmod -R +x hooks

if [ ! -e platforms ];then

    ionic cordova prepare #--verbose

fi