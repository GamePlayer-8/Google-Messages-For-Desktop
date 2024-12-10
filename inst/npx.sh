#!/bin/sh

set -ex

base_version="$(head -n 1 base_version.txt)"
package_version="${base_version}-${1:-0}"

sed -i "s/SOFTVER/${base_version}/g" *.json
sed -i "s/PACKVER/${package_version}/g" *.json

npm install
npm run linux
rm -rf node_modules
tar -cJvf GoogleMessages.tar.xz dist/Linux/GoogleMessages-linux-x64
rm -rf dist
