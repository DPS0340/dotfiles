#!/bin/bash

# Enable debug output
# PS4="\n\033[1;33m>>\033[0m "; set -x

set -x

mkdir ~/pdf ~/paper ~/.ssh/remote > /dev/null 2>&1

chown $USER ~/pdf
chown $USER ~/paper
chown $USER ~/.ssh/remote

_UID=$(id -u $USER)
_GID=$(id -g $USER)

touch ~/nohup-rclone.out

( mount | grep ~/pdf ) || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full --dir-cache-time 1y --poll-interval 1h --vfs-cache-max-age 1y --vfs-cache-min-free-space 10G --vfs-cache-poll-interval 1h google-drive:pdf ~/pdf >> ~/nohup-rclone.out 2>&1 & disown
( mount | grep ~/paper ) || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full --dir-cache-time 1y --poll-interval 1h --vfs-cache-max-age 1y --vfs-cache-min-free-space 10G --vfs-cache-poll-interval 1h google-drive:paper ~/paper >> ~/nohup-rclone.out 2>&1 & disown
( mount | grep ~/.ssh/remote ) || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full --dir-cache-time 1y --poll-interval 1h --vfs-cache-max-age 1y --vfs-cache-min-free-space 10G --vfs-cache-poll-interval 1h google-drive:auth ~/.ssh/remote >> ~/nohup-rclone.out 2>&1 & disown
