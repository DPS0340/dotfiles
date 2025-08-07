#!/usr/bin/env zsh

# Enable debug output
PS4="\n\033[1;33m>>\033[0m "; set -x

mkdir ~/pdf ~/paper ~/.ssh/remote > /dev/null 2>&1

chown $USER ~/pdf
chown $USER ~/paper
chown $USER ~/.ssh/remote

_UID=$(id -u $USER)
_GID=$(id -g $USER)

touch nohup-rclone.out

mount | grep ~/pdf || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:pdf ~/pdf >> ~/dotfiles/nohup-rclone.out 2>&1 &
mount | grep ~/paper || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:paper ~/paper >> ~/dotfiles/nohup-rclone.out 2>&1 &
mount | grep ~/.ssh/remote || nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --uid $_UID --gid $_GID --vfs-cache-mode full google-drive:auth ~/.ssh/remote >> ~/dotfiles/nohup-rclone.out 2>&1 &
