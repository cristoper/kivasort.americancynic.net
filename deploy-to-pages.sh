#!/usr/bin/env sh
set -o errexit
set -o nounset

# get name of current branch before switching
ORIG_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# get revision of previously checked out branch
REV=$(git rev-parse @{0})

MESSAGE="Deploying from ${ORIG_BRANCH} rev ${REV}"

if [ "${ORIG_BRANCH}" = "gh-pages" ]; then
    echo "Cannot deploy from gh-pages itself. Change to dev or master."
    exit 1
fi

git checkout gh-pages

# Unpack output/
cp -r output/* ./

# http://stackoverflow.com/questions/3878624/how-do-i-programmatically-determine-if-there-are-uncommited-changes
git update-index -q --ignore-submodules --refresh

# check if any files changed and check them in if so
if ! $(git diff-files --quiet --ignore-submodules); then
    git commit --all --message "${MESSAGE}" 
    echo "Pushing to origin gh-pages..."
    git push origin gh-pages
else
    echo "Nothing updated."
fi

# back to our original branch
git checkout ${ORIG_BRANCH}
