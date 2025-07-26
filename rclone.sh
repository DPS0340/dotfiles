#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

mkdir ~/pdf ~/paper ~/auth > /dev/null 2>&1

chown $USER ~/pdf
chown $USER ~/paper
chown $USER ~/auth

_UID=$(id -u $USER)
_GID=$(id -g $USER)

touch nohup-rclone.out

mountpoint ~/pdf || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:pdf ~/pdf >> ~/dotfiles/nohup-rclone.out 2>&1 &
mountpoint ~/paper || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:paper ~/paper >> ~/dotfiles/nohup-rclone.out 2>&1 &
mountpoint ~/auth || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:auth ~/auth >> ~/dotfiles/nohup-rclone.out 2>&1 &
