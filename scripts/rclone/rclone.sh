#!/bin/bash

set -u

# .zprofile may run before Nix has added its binaries to PATH.
rclone_bin=$(command -v rclone || true)
if [[ -z "$rclone_bin" && -x "$HOME/.nix-profile/bin/rclone" ]]; then
    rclone_bin="$HOME/.nix-profile/bin/rclone"
fi
if [[ -z "$rclone_bin" ]]; then
    printf 'rclone: executable not found\n' >&2
    exit 1
fi

if ! "$rclone_bin" listremotes | grep -Fxq 'google-drive:'; then
    printf 'rclone: configure the google-drive remote with rclone config first\n' >&2
    exit 1
fi

log_file="$HOME/nohup-rclone.out"
touch "$log_file" || exit 1

# These are personal mounts. Omitting --allow-other also avoids requiring
# user_allow_other in /etc/fuse.conf on a newly installed machine.
mount_options=(
    --daemon --daemon-wait 30s
    --log-level NOTICE --log-file "$log_file" --log-format date,time,pid
    --uid "$(id -u)" --gid "$(id -g)"
    --vfs-cache-mode full --write-back-cache
    --dir-cache-time 1y --poll-interval 1h
    --vfs-cache-max-age 1y --vfs-cache-min-free-space 10G
    --vfs-cache-poll-interval 1h
)

mount_drive() (
    remote_path=$1
    mount_dir=$2
    lock_name=$3
    shift 3

    # Hold the lock until the daemon is ready, without passing it to the daemon.
    exec 9>"$HOME/rclone.mount.$lock_name.lock" || exit 1
    flock -x -n 9 || exit 0
    mountpoint -q -- "$mount_dir" && exit 0

    mkdir -p -- "$mount_dir" || exit 1
    if [[ ! -O "$mount_dir" || ! -w "$mount_dir" ]]; then
        printf 'rclone: mount directory must be owned and writable by the current user: %s\n' "$mount_dir" >&2
        exit 1
    fi

    if ! "$rclone_bin" mount "google-drive:$remote_path" "$mount_dir" \
        "${mount_options[@]}" "$@" 9>&-; then
        printf 'rclone: failed to mount %s; see %s\n' "$mount_dir" "$log_file" >&2
        exit 1
    fi
)

status=0
mount_drive pdf "$HOME/pdf" pdf || status=1
mount_drive paper "$HOME/paper" paper || status=1
mount_drive auth "$HOME/.ssh/remote" ssh-remote --umask 077 || status=1
exit "$status"
