#!/bin/sh

set -ex

rm -rf .flatpak-builder build-dir
cp /tmp/*.tar.xz .
flatpak-builder --install-deps-from=flathub --install --force-clean build-dir io.github.GamePlayer_8.Google_Messages_For_Desktop.yaml
rm -rf .flatpak-builder build-dir
flatpak build-bundle /var/lib/flatpak/repo google-messages.flatpak io.github.GamePlayer_8.Google_Messages_For_Desktop
flatpak uninstall -y --noninteractive io.github.GamePlayer_8.Google_Messages_For_Desktop
