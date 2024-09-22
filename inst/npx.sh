#!/bin/sh

set -ex

apk add --no-cache npm nodejs tar xz

npm install
npm run linux
rm -rf node_modules
tar -cJvf GoogleMessages.tar.xz dist/Linux/GoogleMessages-linux-x64
rm -rf dist
