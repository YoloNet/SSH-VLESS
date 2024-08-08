#!/bin/bash
#Autoscript-Lite By YoLoNET
clear
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
rm -f /var/lib/crot-script/ipvps.conf
rm -f /var/lib/premium-script/ipvps.conf
rm -f /usr/local/etc/xray/domain
echo -e "Please Insert  Your Domain"
read -p "Hostname / Domain: " host
echo "IP=$host" >> /var/lib/crot-script/ipvps.conf
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" > /usr/local/etc/xray/domain
clear
echo -e "Renew Certificate Started . . . ."
echo start
sleep 0.5
source /var/lib/premium-script/ipvps.conf
domain=$(cat /root/yoloautosc/domain)
systemctl stop nginx
systemctl stop xray.service
systemctl stop xray@none.service
systemctl stop xray@vless.service
systemctl stop xray@vnone.service
systemctl stop xray@trojan.service
systemctl stop xray@trnone.service
systemctl stop xray@xtls.service
systemctl stop xray@trojan.service
systemctl stop trojan-go.service
echo -e "[ ${green}INFO${NC} ] Starting renew cert... "
rm -r /root/.acme.sh
sleep 1 
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain -d sshws.$domain --standalone -k ec-256 --listen-v6
~/.acme.sh/acme.sh --installcert -d $domain -d sshws.$domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
chmod 755 /usr/local/etc/xray/xray.key;
service squid start
systemctl restart nginx
sleep 0.5;
clear;
echo -e "[ ${green}INFO${NC} ] Restart All Service" 
systemctl restart nginx
sleep 0.3
systemctl restart xray.service
sleep 0.3
systemctl restart xray@none.service
sleep 0.3
systemctl restart xray@vless.service
sleep 0.3
systemctl restart xray@vnone.service
sleep 0.3
systemctl restart xray@trojanws.service
sleep 0.3
systemctl restart xray@trnone.service
sleep 0.3
systemctl restart xray@xtls.service
sleep 0.3
systemctl restart xray@trojan.service
sleep 0.3
systemctl restart trojan-go.service
sleep 0.3
echo -e "[ ${green}INFO${NC} ] All finished !" 
clear 
neofetch
echo ""
