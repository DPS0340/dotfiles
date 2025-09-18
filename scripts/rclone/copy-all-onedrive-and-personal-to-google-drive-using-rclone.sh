#!/usr/bin/env zsh

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

rclone copy -P -c -u --log-level ERROR onedrive: google-drive:from-onedrive-personal
rclone copy -P -c -u --log-level ERROR onedrive-personal: google-drive:from-onedrive
