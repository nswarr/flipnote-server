#!/usr/bin/env bash

cd /home/flipnote-server/

git fetch origin

NEW_COMMITS=$(git rev-list HEAD...origin/master --count)

if (($NEW_COMMITS > 0)); then
    echo Updating the code.  $NEW_COMMITS new commits found
    git pull
    npm install
    grunt build
    service flipnote restart
else
    echo "[`date -u +%Y-%m-%dT%T.%3NZ`] Nothing to update"
fi
