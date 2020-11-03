#!/bin/bash

# Fail if variables are unset
set -eu -o pipefail

echo '🔧 Install tools'
npm init -y && npm install -y postcss-cli autoprefixer

echo '🤵 Install Hugo'
HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.tag_name')
mkdir tmp/ && cd tmp/
curl -sSL https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION: -6}_Linux-64bit.tar.gz | tar -xvzf-
mv hugo /usr/local/bin/
cd .. && rm -rf tmp/
cd ${GITHUB_WORKSPACE}
cd ${BUILD_DIR}
hugo version || exit 1

echo '👯 Clone remote repository'
git clone https://github.com/${REMOTE} ${DEST} --branch main

echo '🧹 Clean site'
if [ -d "${DEST}" ]; then
    rm -rf ${DEST}/*
fi

echo '🍳 Build site'
hugo -d ${DEST} ${ARGS}

echo '🎁 Publish to remote repository'
cd ${DEST}
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -am "🚀 Deploy with ${GITHUB_WORKFLOW}"
    git remote add publisher "https://${USER}:${TOKEN}@github.com/${REMOTE}"
    git remote -v
    git push -fq publisher main
else
    echo 'No changes to build :)'
fi
