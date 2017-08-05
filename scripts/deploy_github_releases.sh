#!/usr/bin/env bash

if [ "$1" != JOB2 ];then exit; fi

echo TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER    p1=$1

function showGitStatus() {
    echo "=== git status"
        git status
    echo "=== git diff"
        git diff -w
    echo "=== git diff origin/master master"
        git diff origin/master master -w
}

function setupGit() {
    echo "========================================"
    echo "=== setupGit():"
    echo "    cur dir: $PWD"
    mkdir -p ../_tmp_fulltree || exit 1
    cd ../_tmp_fulltree || exit 1
    echo "    cur dir: $PWD"

    git clone --depth=5 https://github.com/ikarus512/tripSave.git || exit 1
    cd tripSave || exit 1
    echo "    cur dir: $PWD"

    # git config --global user.email "travis@travis-ci.org"
    # git config --global user.name "Travis CI"
    git config user.email "$MYEMAIL"
    git config user.name "ikarus512"
    git remote rm origin
    git remote add origin https://ikarus512:${GITHUB_API_TOKEN}@github.com/ikarus512/tripSave.git
    git remote -v
}

function updateTag() {
    echo "========================================"
    echo "=== updateTag():"

    ### Create a git tag of the new version to use
    ### http://phdesign.com.au/programming/auto-increment-project-version-from-travis
    echo "=== Current major/minor version taken from package.json:"
        curMjMn=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})",$/\1/p' package.json)
        curPv=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.)([0-9x]{1,})",$/\2/p' package.json)
        echo curMjMn=$curMjMn
        echo curPv=$curPv
    echo "=== Get the latest git tag (e.g. v1.2.43)"
        git describe
    echo "=== Get tag major/minor version and the patch version:"
        tagMjMn=$(git describe | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\1/g')
        tagPv=$(git describe | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,}).*$/\2/g')
        if [ "$tagMjMn" == "" ];then tagMjMn=$curMjMn; tagPv=$curPv; fi # if current commit not tagged
        echo tagMjMn=$tagMjMn
        echo tagPv=$tagPv
    echo "=== If curMjMn==tagMjMn, increment the patch version, otherwise use major.minor.0:"
        if [ "$curMjMn" == "$tagMjMn" ];then newPv=$(($tagPv+1)); else newPv=0; fi
        newVer=$tagMjMn$newPv
        echo newVer=$newVer
    # echo "=== Save newVer into a git tag (e.g. v1.2.44):"
    #     git tag -a v$newVer -m "[ci skip] (Build #$TRAVIS_BUILD_NUMBER): add tag v$newVer"

    echo "=== Bump version to $newVer inside package.json, commit, and tag"
        npm version $newVer -m "[ci skip] (Build #$TRAVIS_BUILD_NUMBER): v$newVer" || exit 1

    showGitStatus

    echo "=== git push"
        git push origin master --tags || exit 1
}

function publishGithubRelease() {
    echo "========================================"
    echo "=== publishGithubRelease():"
    # https://stackoverflow.com/questions/6335681/git-how-do-i-get-the-latest-version-of-my-code
    # git remote add origin-pages https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
    # git push --quiet --set-upstream origin-pages gh-pages
}

pwd
setupGit
updateTag
publishGithubRelease
pwd
