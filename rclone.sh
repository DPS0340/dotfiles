#!/bin/bash

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

mkdir ~/pdf ~/paper ~/auth > /dev/null 2>&1

umount ~/pdf
umount ~/paper
umount ~/auth

chown $USER ~/pdf
chown $USER ~/paper
chown $USER ~/auth

UID=$(id -u $USER)
GID=$(id -g $USER)

touch nohup-rclone.out

nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $UID --gid $GID --vfs-cache-mode full onedrive-personal:pdf ~/pdf >> ~/dotfiles/nohup-rclone.out 2>&1 &
nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $UID --gid $GID --vfs-cache-mode full onedrive-personal:paper ~/paper >> ~/dotfiles/nohup-rclone.out 2>&1 &
nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $UID --gid $GID --vfs-cache-mode full onedrive:auth ~/auth >> ~/dotfiles/nohup-rclone.out 2>&1 &
