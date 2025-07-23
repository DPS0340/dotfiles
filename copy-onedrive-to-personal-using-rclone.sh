#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

rclone copy -P -c -u --log-level ERROR onedrive:pdf onedrive-personal:pdf
rclone copy -P -c -u --log-level ERROR onedrive:논문 onedrive-personal:paper
rclone copy -P -c -u --log-level ERROR onedrive:auth onedrive-personal:auth

