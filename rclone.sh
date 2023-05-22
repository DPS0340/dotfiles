mkdir ~/pdf ~/논문 ~/auth > /dev/null 2>&1
nohup rclone mount onedrive:pdf ~/pdf > /dev/null 2>&1 &
nohup rclone mount onedrive:논문 ~/논문 > /dev/null 2>&1 &
nohup rclone mount onedrive:auth ~/auth > /dev/null 2>&1 &
