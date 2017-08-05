#!/usr/bin/env bash

if [ "$1" != JOB2 ];then exit; fi

echo TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER    p1=$1

setupGit() {
    echo '========================================'
    echo '=== setupGit():'
    echo '    cur dir: $PWD'
    mkdir -p ../_tmp_fulltree || exit 1
    cd ../_tmp_fulltree || exit 1
    echo '    cur dir: $PWD'

    git clone --depth=5 https://github.com/ikarus512/tripSave.git
    cd tripSave || exit 1
    echo '    cur dir: $PWD'

    # git config --global user.email "travis@travis-ci.org"
    # git config --global user.name "Travis CI"
    git config user.email "$MYEMAIL"
    git config user.name "ikarus512"
    git remote rm origin
    git remote add origin https://ikarus512:${GITHUB_API_TOKEN}@github.com/ikarus512/tripSave.git
    git remote -v
}

updateTag() {
    echo '========================================'
    echo '=== updateTag():'

    ### Create a git tag of the new version to use
    ### http://phdesign.com.au/programming/auto-increment-project-version-from-travis
    echo '=== Current major/minor version taken from package.json:'
        curMjMn=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})",$/\1/p' package.json)
        curPv=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})",$/\2/p' package.json)
        echo curMjMn=$curMjMn
        echo curPv=$curPv
    echo '=== Get the latest git tag (e.g. v1.2.43)'
        git describe
    echo '=== Get tag major/minor version and the patch version:'
        tagMjMn=$(git describe | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\1/g')
        tagPv=$(git describe | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\2/g')
        if [ "$tagMjMn" == "" ];then tagMjMn=$curMjMn; tagPv=$curPv; fi # if current commit not tagged
        echo tagMjMn=$tagMjMn
        echo tagPv=$tagPv
    echo '=== If curMjMn==tagMjMn, increment the patch version, otherwise use major.minor.0:'
        if [ "$curMjMn" == "$tagMjMn" ];then newPv=$(($tagPv+1)); else newPv=0; fi
        newVer=$tagMjMn$newPv
        echo newVer=$newVer
    echo '=== Save newVer into a git tag (e.g. v1.2.44):'
        git tag -a v$newVer -m "v$newVer travis-build-$TRAVIS_BUILD_NUMBER"

    echo '=== Update package.json based on the git tag'
        npm --no-git-tag-version version from-git

    echo '=== git status'
        git status
    echo '=== git diff'
        git diff -w

    echo '=== git add package.json'
        # git add hooks/*
        # git add scripts/*
        git add package.json
        git commit -m "[ci skip] (Travis Build #$TRAVIS_BUILD_NUMBER): package.json version=$newVer"
        # git commit -m "[ci skip] update file attributes"
        # git push origin master
    echo '=== git push'
        git push origin master --tags || exit 1
}

publishGithubRelease() {
    echo '========================================'
    echo '=== publishGithubRelease():'
    # git remote add origin-pages https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
    # git push --quiet --set-upstream origin-pages gh-pages
}

setupGit
updateTag
publishGithubRelease
