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

cd
MYIP=$(curl -sS ipv4.icanhazip.com)
NameUser=$(curl -sS https://raw.githubusercontent.com/YoloNet/IP-Multiport-Websocket/main/access | grep $MYIP | awk '{print $2}')
namaklien=$(cat /root/yoloautosc/clientname.conf)
cekdata=$(curl -sS https://raw.githubusercontent.com/YoloNet/user-manual-backup/main/$namaklien/$namaklien.zip | grep 404 | awk '{print $1}' | cut -d: -f1)

[[ "$cekdata" = "404" ]] && {
red "Data not found / you never backup"
exit 0
} || {
green "Data found for username $namaklien"
}

echo -e "[ ${green}INFO${NC} ] • Restore Data..."
read -rp "Password File: " -e InputPass
echo -e "[ ${green}INFO${NC} ] • Downloading data.."
[[ ! -d /root/backup ]] && mkdir -p /root/backup
wget -q -O /root/backup/backup.zip "https://raw.githubusercontent.com/YoloNet/user-manual-backup/main/$namaklien/$namaklien.zip" &> /dev/null
echo -e "[ ${green}INFO${NC} ] • Getting your data..."
unzip -P $InputPass /root/backup/backup.zip &> /dev/null
echo -e "[ ${green}INFO${NC} ] • Starting to restore data..."
rm -f /root/backup/backup.zip &> /dev/null
sleep 1
cd /root/backup
sleep 1
cp -r /root/backup/premium-script /var/lib/ &> /dev/null
cp -r /root/backup/xray /usr/local/etc/ &> /dev/null
cp -r /root/backup/public_html /home/vps/ &> /dev/null
cp -r /root/backup/crontab /etc/ &> /dev/null
cp -r /root/backup/cron.d /etc/ &> /dev/null
rm -rf /root/backup &> /dev/null
echo -e "[ ${green}INFO${NC} ] • Done..."
sleep 1
echo ""
echo -e "[ ${green}INFO${NC} ] VPS Data Restore Complete !"
echo ""
echo -e "[ ${green}INFO${NC} ] Restart All Service"
systemctl restart nginx
systemctl restart xray.service
systemctl restart xray@none.service
systemctl restart xray@vless.service
systemctl restart xray@vnone.service
systemctl restart xray@trojanws.service
systemctl restart xray@trnone.service
systemctl restart xray@xtls.service
systemctl restart xray@trojan.service
systemctl restart trojan-go.service
service cron restart
sleep 0.5
clear
neofetch
echo ""
rm -f /root/backup/backup.zip &> /dev/null
echo
read -n 1 -s -r -p "Press any key to back on menu"
menu
