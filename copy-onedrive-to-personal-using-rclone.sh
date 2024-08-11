#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

rclone copy --log-level ERROR onedrive:pdf onedrive-personal:pdf
rclone copy --log-level ERROR onedrive:논문 onedrive-personal:paper
