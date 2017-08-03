#!/usr/bin/env bash

#https://unix.stackexchange.com/questions/122460/bash-how-to-let-some-background-processes-run-but-wait-for-others

myappname=tripSave
if [ -z $zipalign ];then zipalign=$ANDROID_HOME1/build-tools/25.0.2/zipalign; fi

### Release build:
# ionic cordova plugin rm cordova-plugin-console
# ionic cordova build android --release -- --keystore=$keystoreFile --alias=$keystoreAlias --storePassword=$storePassword --password=$keyPassword
ionic cordova build android --release || exit 1

pushd platforms/android/build/outputs/apk

    ### keystore:    CN=Your name, OU=OrgUnit, O=Org, L=city/Locality, S=STate/province, C=Country code
    keystoreFile=ikarus512-$myappname.keystore
    keystoreAlias=ikarus512$myappname
    storePassword=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | sha256sum -b | sed 's/ .*//')
    keyPassword=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | sha256sum -b | sed 's/ .*//')
    keystoreValidity=10000 # days

    rm -f $keystoreFile || exit 1
    keytool -genkey -v -noprompt -alias $keystoreAlias -keystore $keystoreFile -storepass $storePassword -keypass $keyPassword -keyalg RSA -keysize 2048 -validity $keystoreValidity -dname "CN=ikarus512, OU=ikarus512, O=HSH, L=NN, S=RU, C=RU" || exit 1

    #android-armv7-release-unsigned.apk
    #android-x86-release-unsigned.apk
    for apkFile in $(ls android-*-release-unsigned.apk);do

        plat=$(echo $apkFile | perl -e '$_=<>; s/^\w+|-release-unsigned.apk$|-armv7//g; print;')
        apkFileOut=$myappname$plat.apk
        rm -f $apkFileOut || exit 1

        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $keystoreFile $apkFile $keystoreAlias -storepass $storePassword -keypass $keyPassword || exit 1
        jarsigner -verify $apkFile $keystoreAlias || exit 1

        $zipalign -v 4 $apkFile $apkFileOut || exit 1

    done

popd
