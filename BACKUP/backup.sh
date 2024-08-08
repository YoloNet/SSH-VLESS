#!/bin/bash
#Autoscript-Lite By YoLoNET
clear
IP=$(wget -qO- icanhazip.com);
date=$(date +"%Y-%m-%d")
clear
echo " VPS Data Backup By YoLoNET "
sleep 1
echo ""
echo " Directory Created"
mkdir /root/backup
sleep 1
echo " Start Backup . . . "
sleep 1
clear
echo " Please Wait VPS Data Backup In Progress . . . "
cp -r /var/lib/premium-script/ /root/backup/premium-script
cp -r /usr/local/etc/xray /root/backup/xray
cp -r /home/vps/public_html /root/backup/public_html
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp -r /etc/crontab /root/backup/crontab &> /dev/null
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
clear
echo -e "\033[1;37mVPS Data Backup By YoLoNET\033[0m
\033[1;37mTelegram : https://t.me/rayyolo / @YoLoNET\033[0m"
echo ""
echo "Please Copy Link Below & Save In Notepad"
echo ""
echo -e "Your VPS IP ( \033[1;37m$IP\033[0m )"
echo ""
echo -e "\033[1;37m$link\033[0m"
echo ""
echo "If you want to restore data, please enter the link above"
rm -rf /root/backup
rm -r /root/$IP-$date.zip
echo ""