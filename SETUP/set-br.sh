#!/bin/bash
# Set-Backup Installation
# By YoLoNET
#-----------------------------
clear
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

Server_URL="$(cat /root/install_link.txt )"

curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://${Server_URL}/rclone.conf"
git clone  https://github.com/MrMan21/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
cd /usr/bin
wget -O backup "https://${Server_URL}/BACKUP/backup.sh"
wget -O backupgithub "https://${Server_URL}/BACKUP/backupgithub.sh"
wget -O backup_tele "https://${Server_URL}/BACKUP/backup_tele.sh"
wget -O restore "https://${Server_URL}/BACKUP/restore.sh"
wget -O restoregithub "https://${Server_URL}/BACKUP/restoregithub.sh"
wget -O restore_tele "https://${Server_URL}/BACKUP/restore_tele.sh"
wget -O cleaner "https://${Server_URL}/BACKUP/logcleaner.sh"
wget -O kumbang "https://${Server_URL}/OTHERS/kumbang.sh"
chmod +x /usr/bin/backup
chmod +x /usr/bin/backupgithub
chmod +x /usr/bin/restore
chmod +x /usr/bin/restoregithub
chmod +x /usr/bin/cleaner
chmod +x /usr/bin/kumbang
chmod +x /usr/bin/backup_tele
chmod +x /usr/bin/restore_tele
cd
if [ ! -f "/etc/cron.d/cleaner" ]; then
cat> /etc/cron.d/cleaner << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/cleaner
END
fi
service cron restart > /dev/null 2>&1
rm -f /root/set-br.sh