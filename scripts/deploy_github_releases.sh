#!/usr/bin/env bash

echo TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
  # git config user.email "$MYEMAIL"
  # git config user.name "ikarus512"
  # git remote add gh-token "${GH_REF}"
  # git remote add origin https://github.com/ikarus512/tripSave.git
  git remote rm origin
  git remote add origin https://${GITHUB_API_TOKEN}@github.com/ikarus512/tripSave.git
}

commit_website_files() {
  git checkout -b gh-pages
  git add . *.html
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin-pages https://${GH_TOKEN}@github.com/MVSE-outreach/resources.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages gh-pages
}

setup_git
# commit_website_files
# upload_files

    git add hooks/*
    git add scripts/*
    git commit -m "[ci skip] update file attributes"

    git push origin master
    # @$GITHUB_API_TOKEN
    # git push -f -q https://ikarus512:$GITHUB_API_TOKEN@github.com/ikarus512/tripSave master

echo '=== git status'
    git status
echo '=== git diff'
    git diff -w

### Create a git tag of the new version to use
### http://phdesign.com.au/programming/auto-increment-project-version-from-travis
echo '=== Current major/minor version taken from package.json:'
    curMjMn=$(sed -nE 's/^[ \t]*"version": "([0-9]{1,}\.[0-9]{1,}\.)[0-9x]{1,}",$/\1/p' package.json)
    echo curMjMn=$curMjMn
echo '=== Get the latest git tag (e.g. v1.2.43)'
    git describe --abbrev=0 || exit 1
echo '=== Get tag major/minor version and the patch version:'
    tagMjMn=$(git describe --abbrev=0 | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,})$/\1/g')
    tagPv=$(git describe --abbrev=0 | sed -E 's/^v([0-9]{1,}\.[0-9]{1,}\.)([0-9]{1,})$/\2/g')
    echo tagMjMn=$tagMjMn
    echo tagPv=$tagPv
echo '=== If curMjMn==tagMjMn, increment the patch version, otherwise use major.minor.0:'
    if [ "$curMjMn" == "$tagMjMn" ];then newPv=$(($tagPv+1)); else newPv=0; fi
    newVer=$tagMjMn$newPv
    echo newVer=$newVer
echo '=== Save resulting version number into a git tag (e.g. v1.2.44):'
    git tag -a v$newVer -m "v$newVer travis-build-$TRAVIS_BUILD_NUMBER"

echo '=== Update package.json based on the git tag'
    npm --no-git-tag-version version from-git

echo '=== git status'
    git status
echo '=== git diff'
    git diff -w

echo '=== git push --tags'
    git push --tags || exit 1
