#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

rclone copy -P -c -u --log-level ERROR onedrive-personal:pdf google-drive:pdf
rclone copy -P -c -u --log-level ERROR onedrive-personal:paper google-drive:paper
rclone copy -P -c -u --log-level ERROR onedrive-personal:auth google-drive:auth
