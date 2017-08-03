#!/usr/bin/env bash

echo "ERROR: cordova cannot build debug and release in parallel in same place!"
exit


#https://unix.stackexchange.com/questions/122460/bash-how-to-let-some-background-processes-run-but-wait-for-others

apkdir=platforms/android/build/outputs/apk
if [ -e $apkdir ];then
    ls $apkdir
    rm -f $apkdir/*.apk
    rm -f $apkdir/*.keystore
    ls $apkdir
fi

tmp1=$(mktemp)
tmp2=$(mktemp)
(scripts/ionic_cordova_build_android_debug.sh   >tmp.build.debug.txt   2>&1; echo $? >"$tmp1") &
pid1=$!
(scripts/ionic_cordova_build_android_release.sh >tmp.build.release.txt 2>&1; echo $? >"$tmp2") &
pid2=$!
wait "$pid1" "$pid2"

cat tmp.build.debug.txt
cat tmp.build.release.txt

read ret1 <"$tmp1" # read status code into $ret1
read ret2 <"$tmp2" # read status code into $ret2
[ "$ret1" = 0 && "$ret2" = 0 ]
