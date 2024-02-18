mkdir ~/pdf ~/논문 ~/auth > /dev/null 2>&1

sudo umount -lf ~/pdf
sudo umount -lf ~/논문
sudo umount -lf ~/auth

sudo chown $USER pdf
sudo chown $USER 논문
sudo chown $USER pdf

nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --allow-root --default-permissions --vfs-cache-mode full onedrive:pdf ~/pdf &
nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --allow-root --default-permissions --vfs-cache-mode full onedrive:논문 ~/논문 &
nohup rclone mount --allow-non-empty --log-level ERROR --allow-other --allow-root --default-permissions --vfs-cache-mode full onedrive:auth ~/auth &
