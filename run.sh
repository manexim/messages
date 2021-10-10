#!/bin/bash

APP=com.github.manexim.messages

flatpak-builder --repo=repo --disable-rofiles-fuse build ${APP}.yml --force-clean
flatpak build-bundle repo ${APP}.flatpak --runtime-repo=https://flatpak.elementary.io/repo.flatpakrepo ${APP} master
flatpak-builder --run build ${APP}.yml ${APP}
