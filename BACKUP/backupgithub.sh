#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/YoloNet/IP-Multiport-Websocket/main/access | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

IP=$(curl -sS ipv4.icanhazip.com);
date=$(date +"%Y-%m-%d")

MYIP=$(curl -sS ipv4.icanhazip.com)
NameUser=$(curl -sS https://raw.githubusercontent.com/YoloNet/IP-Multiport-Websocket/main/access | grep $MYIP | awk '{print $2}')
namaklien=$(cat /root/yoloautosc/clientname.conf)
clear
echo -e "[ ${green}INFO${NC} ] Create password for database"
read -rp "Enter password : " -e InputPass
sleep 1
if [[ -z $InputPass ]]; then
exit 0
fi
echo -e "[ ${green}INFO${NC} ] Processing... "
mkdir -p /root/backup
sleep 1
clear
echo " Please Wait VPS Data Backup In Progress . . . "
cp -r /var/lib/premium-script/ /root/backup/premium-script
cp -r /usr/local/etc/xray /root/backup/xray
cp -r /home/vps/public_html /root/backup/public_html
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp -r /etc/crontab /root/backup/crontab &> /dev/null
cd /root
zip -rP $InputPass $namaklien.zip backup > /dev/null 2>&1

##############++++++++++++++++++++++++#############
LLatest=`date`
Get_Data () {
git clone https://github.com/YoloNet/user-manual-backup.git /root/user-backup/ &> /dev/null
}

Mkdir_Data () {
mkdir -p /root/user-backup/$namaklien
}

Input_Data_Append () {
if [ ! -f "/root/user-backup/$namaklien/$namaklien-last-backup" ]; then
touch /root/user-backup/$namaklien/$namaklien-last-backup
fi
echo -e "User         : $namaklien
last-backup : $LLatest
" >> /root/user-backup/$namaklien/$namaklien-last-backup
mv /root/$namaklien.zip /root/user-backup/$namaklien/
}

Save_And_Exit () {
    cd /root/user-backup
    git config --global user.email "rayrjtech@gmail.com" &> /dev/null
    git config --global user.name "YoloNet" &> /dev/null
    rm -rf .git &> /dev/null
    git init &> /dev/null
    git add . &> /dev/null
    git commit -m m &> /dev/null
    git branch -M main &> /dev/null
    git remote add origin https://github.com/YoloNet/user-manual-backup
    git push -f https://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@github.com/YoloNet/user-manual-backup.git &> /dev/null
}

if [ ! -d "/root/user-backup/" ]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting database... "
Get_Data
Mkdir_Data
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting info server... "
Input_Data_Append
sleep 1
echo -e "[ ${green}INFO${NC} ] Processing updating server...... "
Save_And_Exit
fi
link="https://raw.githubusercontent.com/YoloNet/user-manual-backup/main/$namaklien/$namaklien.zip"
sleep 1
echo -e "[ ${green}INFO${NC} ] Backup done "
sleep 1
echo
sleep 1
echo -e "[ ${green}INFO${NC} ] Generete Link Backup "
echo
sleep 2
echo -e "The following is a link to your vps data backup file.
Your VPS IP $IP

$link
save the link pliss!

If you want to restore data, please enter the link above.
Thank You For Using Our Services"

rm -rf /root/backup &> /dev/null
rm -rf /root/user-backup &> /dev/null
rm -f /root/$namaklien.zip &> /dev/null
echo
read -n 1 -s -r -p "Press any key to back on menu"
menu
