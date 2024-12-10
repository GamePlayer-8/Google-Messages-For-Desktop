#!/bin/sh

set -ex

SCRIPT_PATH="$(realpath "$(dirname "$0")")"
BUILD_RUNTIME="${BUILD_RUNTIME:-$1}"
BUILD_RUNTIME="${BUILD_RUNTIME:-/tmp}"

build_dir="${BUILD_RUNTIME}/build"

cp -r /source "$build_dir"

cd "$build_dir"

base_version="$(head -n 1 base_version.txt)"
package_version="${base_version}-${2:-1}"
current_date="$(date +%Y-%m-%d)"

sed -i "s/SOFTVER/${base_version}/g" *.metainfo.xml
sed -i "s/SOFTVER/${base_version}/g" *.yaml
sed -i "s/SOFTVER/${base_version}/g" *.json

sed -i "s/PACKVER/${package_version}/g" *.metainfo.xml
sed -i "s/PACKVER/${package_version}/g" *.yaml
sed -i "s/PACKVER/${package_version}/g" *.json

export first_commit="$(git rev-list HEAD | tail -n 1)"
export xml_tags="$(git tag | \
        xargs -P 1 -I '{}' sh -c \
            'echo -n "<release|date=\"$(git log -1 --format=%ai "{}" | cut -f 1 -d " ")\"|version=\""; \
                echo -n "$(echo -n "$(git show "{}:base_version.txt" 2>/dev/null || echo "{}")" | rev | cut -f 1 -d 'v' | rev)-"; \
                echo -n "$(echo "{}" | rev | cut -f 1 -d 'v' | rev)."; \
                echo -n "$(git rev-list --count "$first_commit..{}")"; echo "\"/>"' | \
                    tr '\n' ' ' | sed 's/ $//' | rev | tr ' ' '\n' | rev | sed -e 's/|/ /g')"

for X in $(echo "$xml_tags" | tr ' ' '|' | tac); do
    value="$(echo "$X" | tr '|' ' ')"
    if ! grep -q "$value" *.metainfo.xml; then
        sed -i "s|<releases>|<releases>\n    $value|g" *.metainfo.xml
    fi
done

sed "s|<releases>|<releases>\n    $(echo -n $xml_tags)|g" *.metainfo.xml

if grep -q 'version="'"$package_version"'"' *.metainfo.xml; then
    updated_release="$(grep 'version="'"$package_version"'"' *.metainfo.xml | sed -E "s/(<release date=\")[0-9]{4}-[0-9]{2}-[0-9]{2}(\")/\1$current_date\2/")"
    sed -i "s|$(grep 'version="'"$package_version"'"' *.metainfo.xml)|${updated_release}|g" *.metainfo.xml
else
    updated_release='<release date="'"$current_date"'" version="'"$package_version"'"/>"'
    sed -i "s|<releases>|<releases>\n    $updated_release|g" *.metainfo.xml
fi

cat *.metainfo.xml

cat *.yaml

sh inst/package.sh
sh inst/post.sh

cd -
