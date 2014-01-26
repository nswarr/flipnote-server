#!/usr/bin/env bash

cd /home/flipnote-server/

git fetch origin

NEW_COMMITS=$(git rev-list HEAD...origin/master --count)

if (($NEW_COMMITS > 0)); then
    echo Updating the code.  $NEW_COMMITS new commits found
    git pull
    npm install
    grunt prod
else
    echo Nothing to update
fi
