#!/bin/bash
set -e

#------------------------------#
# Install Base, SDK, & Runtime #
#------------------------------#

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# get sdk, platform, and runtime version from manifest
SDK=$(cat flatpak/*.json | jq -r '.sdk')
RUNTIME=$(cat flatpak/*.json | jq -r '.runtime')
RUNTIME_VERSION="$(cat flatpak/*.json | jq -r ".[\"runtime-version\"]")"
BASE=$(cat flatpak/*.json | jq -r '.base')
BASE_VERSION="$(cat flatpak/*.json | jq -r ".[\"base-version\"]")"
# Install required dependencies
flatpak install -y flathub \
  "$SDK"/x86_64/"$RUNTIME_VERSION" \
  "$RUNTIME"/x86_64/"$RUNTIME_VERSION" \
  "$BASE"/x86_64/"$BASE_VERSION"

# Build flatpak
flatpak-builder --disable-rofiles-fuse --force-clean build-dir flatpak/*.json

# Create a bundle
flatpak build-bundle 
