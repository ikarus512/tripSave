#!/usr/bin/env bash

source scripts/_github_api.sh

githubTagAndPublishRelease ikarus512/tripSave

#git fetch origin; git merge --no-edit -m "[ci skip] merge branch 'master' of github.com:ikarus512/tripSave"; git add -A; git commit -m "deploy experiments: tag"; git push origin master
