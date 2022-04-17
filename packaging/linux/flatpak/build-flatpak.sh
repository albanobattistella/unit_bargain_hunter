#!/bin/bash

projectId=codes.merritt.bargain
executableName=unit_bargain_hunter

# This script is triggered by the json manifest.
# It can also be run manually: flatpak-builder build-dir $projectId.json

# Exit if any command fails
set -e

# Extract portable Flutter build.
mkdir -p $projectId
tar -xf $projectId-Linux-Portable.tar.gz -C $projectId
rm $projectId/PORTABLE

# Copy the portable app to the Flatpak-based location.
cp -r $projectId /app/
chmod +x /app/$projectId/$executableName
mkdir -p /app/bin
ln -s /app/$projectId/$executableName /app/bin/$executableName

# Install the AppStream metadata info.
mkdir -p /app/share/metainfo
cp -r $projectId.metainfo.xml /app/share/metainfo/

# Install the icon.
iconDir=/app/share/icons/hicolor/scalable/apps
mkdir -p $iconDir
cp -r icon.svg $iconDir/$projectId.svg

# Install the desktop file.
desktopFileDir=/app/share/applications
mkdir -p $desktopFileDir
cp -r $projectId.desktop $desktopFileDir/

# Install the AppStream metadata file.
metadataDir=/app/share/appdata
mkdir -p $metadataDir
cp -r $projectId.metainfo.xml $metadataDir/
