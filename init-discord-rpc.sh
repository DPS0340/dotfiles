#!/bin/bash

# Wsl2 only

set -x

pkill socat
rm -f /var/run/discord-ipc-0

socat UNIX-LISTEN:/var/run/discord-ipc-0,fork \
    EXEC:"npiperelay.exe //./pipe/discord-ipc-0" &

sleep 2
chmod 777 /var/run/discord-ipc-0
