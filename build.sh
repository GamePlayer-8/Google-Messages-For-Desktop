#!/bin/sh

set -ex

SCRIPT_PATH="$(realpath "$(dirname "$0")")"

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
