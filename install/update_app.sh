#!/usr/bin/env bash

cd /home/flipnote-server/

git fetch origin

NEW_COMMITS=$(git rev-list HEAD...origin/master --count)

if [$NEW_COMMITS -gt 0]; then
    echo 'Updating the code.  $NEW_COMMITS new commits found'
    git pull
    grunt build
    service flipnote restart
fi
