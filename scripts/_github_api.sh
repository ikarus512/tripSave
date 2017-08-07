#!/usr/bin/env bash

# file: _github_api.sh
# /*!
#  * Copyright 2017 ikarus512
#  * https://github.com/ikarus512/tripSave.git
#  *
#  * DESCRIPTION: Functions to Publish GitHub Release with Binary Assets
#  * AUTHOR: ikarus512
#  * CREATED: 2017/08/07
#  *
#  * MODIFICATION HISTORY
#  *  2017/08/07, ikarus512. Initial version.
#  *
#  */


function githubReleaseCreate() {

    ### get params
    local REPO=$1; shift
    local tag="$1"; shift
    ### print params
    local func=${FUNCNAME[0]}
    echo "========================================"
    echo "====  function $func(REPO=$REPO, tag=$tag):"
    ### check params
    if [ "$REPO" == "" -o "$tag" == "" ];then
        echo -e "====  Error in $func parameters. Call example: $func username/repository v1.0.0"
        return 1
    fi
    ### global variables
    if [ "$GITHUB_API_TOKEN" == "" ];then echo "Error: GITHUB_API_TOKEN env var not defined."; return 1; fi
    ### local variables
    local URL_API payload res
    URL_API="--silent --location https://api.github.com/repos/$REPO/releases"
    payload=$(printf '{"tag_name": "%s", "target_commitish": "master", "name": "%s", "body": "Release of version %s", "draft": false, "prerelease": false}' $tag $tag $tag)

    echo "====    create release if not exists"
    res=$(curl -X POST --data "$payload" --header "Authorization: token $GITHUB_API_TOKEN" $URL_API)
    echo $res

}

function githubReleaseGetId() {

    ### get params
    local REPO=$1; shift
    local tag="$1"; shift
    ### print params
    local func=${FUNCNAME[0]}
    echo "========================================"
    echo "====  function $func(REPO=$REPO, tag=$tag): returns \$result == release id"
    ### check params
    if [ "$REPO" == "" -o "$tag" == "" ];then
        echo -e "====  Error in $func parameters.\n  Call example: $func username/repository v1.0.0"
        return 1
    fi
    ### global variables
    if [ "$GITHUB_API_TOKEN" == "" ];then echo "Error: GITHUB_API_TOKEN env var not defined."; return 1; fi
    ### local variables
    local URL_API payload res
    URL_API="--silent --location https://api.github.com/repos/$REPO/releases"
    payload=$(printf '{"tag_name": "%s", "target_commitish": "master", "name": "%s", "body": "Release of version %s", "draft": false, "prerelease": false}' $tag $tag $tag)
    ### global output: $result (release id)
    result=undefined

    echo "====    get release id"
    res=$(curl -X GET --data "$payload" --header "Authorization: token $GITHUB_API_TOKEN" $URL_API/tags/$tag)
    echo $res

    result=$(node -pe 'JSON.parse(process.argv[1]).id' "$res")

}

function githubReleaseUploadAsset() {

    ### get params
    local REPO=$1; shift
    local tag="$1"; shift
    local aFile="$1"; shift
    ### print params
    local func=${FUNCNAME[0]}
    echo "========================================"
    echo "====  function $func(REPO=$REPO, tag=$tag, file=$aFile):"
    ### check params
    if [ "$REPO" == "" -o "$tag" == "" -o "$aFile" == "" ];then
        echo -e "====  Error in $func parameters. Call example: $func username/repository v1.0.0 filePath"
        return 1
    fi
    if [ ! -e $aFile ];then echo not found $aFile; fi
    ### global variables
    if [ "$GITHUB_API_TOKEN" == "" ];then echo "Error: GITHUB_API_TOKEN env var not defined."; return 1; fi
    ### local variables
    local URL_UPL msg res release_id
    URL_UPL="--silent --location https://uploads.github.com/repos/$REPO/releases"

    ### get release id for the given tag
    githubReleaseGetId $REPO $tag >/dev/null; release_id=$result
    if [ "$release_id" == "" -o "$release_id" == "undefined" ];then
        echo "====  Error: release for tag=$tag not found"
        return 1
    fi
    echo "====  release_id==$release_id"

    # for aFile in $assets;do echo $aFile; errors=$(($errors+1)); done
    # if [ $errors -ne 0 ];then echo "====  Error: uploading assets failed"; return 1; fi

    ### upload asset
    res=$(curl -X POST \
        --header "Authorization: token $GITHUB_API_TOKEN" \
        --header "Content-Type: application/octet-stream" \
        --data-binary @"$aFile" \
        $URL_UPL/$release_id/assets?name=$(basename $aFile))
    echo $res
    msg=$(node -pe 'JSON.parse(process.argv[1]).message' "$res")
    if [ "$msg" != "undefined" ];then echo "Error in $func: could not upload asset $aFile"; return 1; fi

}

function githubReleaseDelete() {

    ### get params
    local REPO=$1; shift
    local tag="$1"; shift
    ### print params
    local func=${FUNCNAME[0]}
    echo "========================================"
    echo "====  function $func(REPO=$REPO, tag=$tag):"
    ### check params
    if [ "$REPO" == "" -o "$tag" == "" ];then
        echo -e "====  Error in $func parameters. Call example: $func username/repository v1.0.0"
        return 1
    fi
    ### global variables
    if [ "$GITHUB_API_TOKEN" == "" ];then echo "Error: GITHUB_API_TOKEN env var not defined."; return 1; fi
    ### local variables
    local URL_API res release_id
    URL_API="--silent --location https://api.github.com/repos/$REPO/releases"

    ### get release id for the given tag
    githubReleaseGetId $REPO $tag >/dev/null; release_id=$result
    if [ "$release_id" == "" -o "$release_id" == "undefined" ];then
        echo "====  Error: release for tag=$tag not found"
        return 1
    fi
    echo "====  release_id==$release_id"

    ### delete release
    res=$(curl -X DELETE --data "$payload" --header "Authorization: token $GITHUB_API_TOKEN" $URL_API/$release_id)
    echo $res code=$?

}

function cloneRepo() {
    local REPO=$1
    local dir=$2
    if [ ! -d $dir ];then
        echo git clone --depth=20 https://ikarus512:$GITHUB_API_TOKEN@github.com/$REPO.git $dir
        git clone --depth=20 https://ikarus512:$GITHUB_API_TOKEN@github.com/$REPO.git $dir
        # pushd $dir
        #     git config --global user.email "travis@travis-ci.org"
        #     git config --global user.name "Travis CI"
        #     git config user.email "$MYEMAIL"
        #     git config user.name "ikarus512"
        #     git remote rm origin
        #     git remote add origin https://ikarus512:${GITHUB_API_TOKEN}@github.com/ikarus512/tripSave.git
        #     git remote -v
        # popd
    fi
}

function getPackageVersion() {
    result=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.[0-9x]{1,})",$/\1/p' package.json)
}

function getLatestTag() {
    local REPO=$1
    cloneRepo $REPO _tmp/tripSave
    pushd _tmp/tripSave >/dev/null
        git fetch
        result=$(git describe --tags | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}).*$/\1/g')
    popd >/dev/null
}

function getLatestBuildNumber() {
    local REPO=$1
    cloneRepo $REPO _tmp/tripSave
    pushd _tmp/tripSave >/dev/null
        git fetch
        result=$(cat .travis.latest.build.number.txt 2>/dev/null) || result=0
    popd >/dev/null
}

function getNewTagBumped() {

    curVer=$1; shift
    tagVer=$1; shift

    ### Create a git tag of the new version to use
    ### http://phdesign.com.au/programming/auto-increment-project-version-from-travis
    # echo "=== Current major/minor version taken from package.json:"
        curMjMn=$(echo $curVer | sed -nE 's/^([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})$/\1/p')
        curPv=$(echo $curVer | sed -nE 's/^([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})$/\2/p')
        # echo curMjMn=$curMjMn
        # echo curPv=$curPv
    # echo "=== Get the latest git tag (e.g. v1.2.43)"
        # echo $tagVer
    # echo "=== Get tag major/minor version and the patch version:"
        tagMjMn=$(echo $tagVer | sed -E 's/^([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\1/g')
        tagPv=$(echo $tagVer | sed -E 's/^([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\2/g')
        if [ "$tagMjMn" == "" ];then tagMjMn=$curMjMn; tagPv=$curPv; fi # if current commit not tagged
        # echo tagMjMn=$tagMjMn
        # echo tagPv=$tagPv
    # echo "=== If curMjMn==tagMjMn, increment the patch version, otherwise use major.minor.0:"
        if [ "$curMjMn" == "$tagMjMn" ];then newPv=$(($tagPv+1)); else newPv=0; fi
        newVer=$curMjMn$newPv
        # echo newVer=$newVer
    result=$newVer

}

function githubTagAndPublishRelease() {

    ### get params
    local REPO=$1; shift
    ### print params
    local func=${FUNCNAME[0]}
    echo "========================================"
    echo "====  function $func(REPO=$REPO):"
    ### check params
    if [ "$REPO" == "" ];then
        echo -e "====  Error in $func parameters. Call example: $func username/repository"
        return 1
    fi
    ### global variables
    if [ "$GITHUB_API_TOKEN" == "" ];then echo "Error: GITHUB_API_TOKEN env var not defined."; return 1; fi
    ### local variables
    local errors res release_id
    errors=0

    ### Running from Travis CI:
    ### if [ "$TRAVIS_BUILD_NUMBER" != "" ];then
    ###     if [ "$TRAVIS_BUILD_NUMBER" != "latestBuildNumber" ];then
    ###         echo $TRAVIS_BUILD_NUMBER >.travis.latest.build.number.txt
    ###         git add .travis.latest.build.number.txt
    ###         bump package version
    ###         git tag, commit, push
    ###     getLatestTag
    ###         create github release
    ###         add assets
    ###         ?remove previous release

    if [ "$TRAVIS_BUILD_NUMBER" != "" ];then

        getLatestBuildNumber $REPO; latestBuildNumber=$result; echo "=== latestBuildNumber=$latestBuildNumber"

        if [ "$TRAVIS_BUILD_NUMBER" != "latestBuildNumber" ];then

            pushd _tmp/tripSave >/dev/null
                echo $TRAVIS_BUILD_NUMBER >.travis.latest.build.number.txt
                git add .travis.latest.build.number.txt || errors=$(($errors+1))
            popd >/dev/null
            if [ $errors -eq 0 ];then echo "Error in $func"; return 1; fi

            # bump package version
            getPackageVersion; packageVersion=$result; echo "=== packageVersion=$packageVersion"
            getLatestTag $REPO; latestTag=$result; echo "=== latestTag=$latestTag"
            getNewTagBumped $packageVersion $latestTag; newTag=$result; echo "=== newTag=$newTag"

            # git tag, commit, push
            pushd _tmp/tripSave >/dev/null
                ### echo "=== Save newVer into a git tag (e.g. v1.2.44):"
                ###     git tag -a v$newVer -m "[ci skip] (Travis Build #$TRAVIS_BUILD_NUMBER): add tag v$newVer"
                # echo "=== Bump version to $newVer inside package.json, commit, and tag"
                if [ "$TRAVIS_BUILD_NUMBER" == "" ];then
                    npm version $newVer -m "[ci skip]: bumped tag v$newVer" || errors=$(($errors+1))
                else
                    npm version $newVer -m "[ci skip] (Travis Build #$TRAVIS_BUILD_NUMBER): bumped tag v$newVer" || errors=$(($errors+1))
                fi
                # echo "=== git push"
                if [ $errors -eq 0 ];then
                    git push origin master --tags || errors=$(($errors+1))
                fi
            popd >/dev/null
            if [ $errors -eq 0 ];then echo "Error in $func"; return 1; fi

        fi

        getLatestTag $REPO; latestTag=$result; echo "=== latestTag=$latestTag"
        githubReleaseCreate $REPO $latestTag
        myappname=tripSave
        case $JOBNAME in
        tripSave_debug)
            githubReleaseUploadAsset $REPO $latestTag releases/$myappname-debug.apk
            githubReleaseUploadAsset $REPO $latestTag releases/$myappname-debug-x86.apk
        ;;
        tripSave_release)
            githubReleaseUploadAsset $REPO $latestTag releases/$myappname.apk
            githubReleaseUploadAsset $REPO $latestTag releases/$myappname-x86.apk
        ;;
        esac

    fi

}

# REPO=ikarus512/tripSave
# tag=v1.0.14
# aFile=platforms/android/build/outputs/apk/tripSave3.apk

# githubReleaseCreate $REPO $tag
# githubReleaseUploadAsset $REPO $tag $aFile
# githubReleaseDelete $REPO $tag
# githubTagAndPublishRelease $REPO
