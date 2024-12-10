#!/bin/sh

set -ex

SCRIPT_PATH="$(realpath "$(dirname "$0")")"

NPROC_CPUS="${NPROC_CPUS:-$2}"
NPROC_CPUS="${NPROC_CPUS:-$(nproc --all)}"
export NPROC_CPUS

VERSION="${VERSION:-$3}"
VERSION="${VERSION:-$(git describe --tags --abbrev=0 | rev | cut -f 1 -d 'v' | rev).$(git rev-list --count HEAD)}"
export VERSION

cd "$SCRIPT_PATH"

case "$1" in
        "build")
                docker compose build
                ;;
        "run")
                docker compose up
                ;;
        "clean")
                docker compose down --remove-orphans -v --rmi all
                ;;
        *)
                docker compose build
                docker compose up
                ;;
esac
