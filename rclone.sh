mkdir ~/pdf ~/논문 ~/auth > /dev/null 2>&1
nohup rclone mount --default-permissions --vfs-cache-mode full onedrive:pdf ~/pdf > /dev/null 2>&1 &
nohup rclone mount --default-permissions --vfs-cache-mode full onedrive:논문 ~/논문 > /dev/null 2>&1 &
nohup rclone mount --default-permissions --vfs-cache-mode full onedrive:auth ~/auth > /dev/null 2>&1 &
