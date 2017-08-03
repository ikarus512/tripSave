#!/usr/bin/env bash

tmp1=$(mktemp)
tmp2=$(mktemp)
(scripts/ionic_cordova_build_android_debug.sh >tmp.build.debug.txt 2>&1; echo $? >"$tmp1") &
pid1=$!
(scripts/ionic_cordova_build_android_release.sh >tmp.build.release.txt 2>&1 ; echo $? >"$tmp2") &
pid2=$!
wait "$pid1" "$pid2"

cat tmp.build.debug.txt
cat tmp.build.release.txt

read ret1 <"$tmp1"
read ret2 <"$tmp2"
[ "$ret1" = 0 && "ret2" = 0 ]
