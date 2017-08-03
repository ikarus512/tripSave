#!/usr/bin/env bash

myappname=tripSave
if [ -z $zipalign ];then zipalign=$ANDROID_HOME1/build-tools/25.0.2/zipalign; fi

### remove debug plugins
ionic cordova plugin rm cordova-plugin-console

### build
ionic cordova build android --release || exit 1

### keystore:    CN=Your name, OU=OrgUnit, O=Org, L=city/Locality, S=STate/province, C=Country code
keystoreFile=ikarus512-$myappname.keystore
keystoreAlias=ikarus512$myappname
storePassword=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | sha256sum -b | sed 's/ .*//')
keyPassword=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | sha256sum -b | sed 's/ .*//')
keystoreValidity=10000 # days
rm -f $keystoreFile || exit 1
keytool -genkey -v -noprompt -alias $keystoreAlias -keystore $keystoreFile -storepass $storePassword -keypass $keyPassword -keyalg RSA -keysize 2048 -validity $keystoreValidity -dname "CN=ikarus512, OU=ikarus512, O=HSH, L=NN, S=RU, C=RU" || exit 1

### sign and copy to ./releases/ for later check-in
for apkFile in $(ls platforms/android/build/outputs/apk/android-*-release-unsigned.apk);do

    plat=$(echo $apkFile | perl -e '$_=<>; s/^.*\/\w+|-release-unsigned.apk$|-armv7//g; print;')
    apkFileOut=releases/$myappname$plat.apk
    rm -f $apkFileOut || exit 1

    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $keystoreFile $apkFile $keystoreAlias -storepass $storePassword -keypass $keyPassword || exit 1
    jarsigner -verify $apkFile $keystoreAlias || exit 1

    $zipalign -v 4 $apkFile $apkFileOut || exit 1

done

rm -fv platforms/android/build/outputs/apk/*release*.apk
