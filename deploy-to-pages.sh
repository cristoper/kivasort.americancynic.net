#!/usr/bin/env sh

git checkout gh-pages

# get name of previously checked out branch
PREV_BRANCH=$(basename $(git rev-parse --symbolic-full-name @{-1}))

# get revision of previously checked out branch
REV=$(git rev-parse @{-1})

MESSAGE="Deploying from ${PREV_BRANCH} rev ${REV}"

# copy new output files over gh-pages files
cp -r output/* ./
git commit --all --message "'${MESSAGE}'"
echo git push origin gh-pages
git checkout ${PREV_BRANCH}
