#!/bin/bash
#@authors: YoLoNET
#TELEGRAM : @RAYYOLO
#Script Auto Install xray

#colors
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'

purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }

#get date and time
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear

#installing some dependencies
apt update -y
apt upgrade -y
apt -y install wget curl
apt install socat -y
apt install python -y
apt install curl -y
apt install wget -y
apt install sed -y
apt install nano -y
apt install python3 -y
apt install toilet -y
apt install figlet -y
apt install jq -y
apt install gawk -y
apt install bison -y


#start script installation
echo -e "\e[0;32mCHECKING IP PERMISSION...\e[0m"

cd
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
MYIP=$(wget -qO- icanhazip.com/ip);
secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minutes $(( ${1} % 60 )) seconds"
}
start=$(date +%s)

echo -e "[ ${green}INFO${NC} ] Preparing the autoscript installation ~"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Installation file is ready to begin !"
sleep 1

if [ -f "/usr/local/etc/xray/domain" ]; then
echo "Script Already Installed"
exit 0
fi

#make directory
mkdir /var/lib/premium-script;
mkdir /var/lib/crot-script;
mkdir /usr/local/etc/xray;
mkdir /root/yoloautosc;
clear

#Ask for servinstall_link_url
read -p "Enter your script installation link without http:// or https:// and no '/' at end: " install_link_url
echo "${install_link_url}" > /root/install_link.txt
Server_URL="$(cat /root/install_link.txt )"
clear

#Gathering Server Info
echo -e ""
echo -e " ${green}Please Insert Domain${NC}"
echo -e ""
read -p " Hostname / Domain: " host
echo -e ""
echo -e " ${green}Please Insert Client Name${NC}"
echo -e ""
read -p " Client Name : " clientname
echo -e " [ ${green}SC  By YoLoNET 2022 modded by redvpn${NC} ] "
echo -e ""
echo -e " ${green}Please Insert Your Telegram BOT TOKEN${NC}"
echo -e " ${green}Create Your Telegram Bot Using @BotFather${NC}"
echo -e ""
read -p " TELEGRAM BOT TOKEN: " tele_token
echo -e ""
echo -e " ${green}Please Insert Your Telegram CHAT ID${NC}"
echo -e " ${green}get Your Telegram CHAT ID from BOT @MissRose_bot${NC}"
echo -e ""
read -p " TELEGRAM CHAT ID: " tele_id
echo -e ""
clear

# / / saving information to /var/lib
echo "IP=$host" > /var/lib/premium-script/ipvps.conf
echo "IP=$host" > /var/lib/crot-script/ipvps.conf
echo "$host" > /root/domain
domaiin=$(cat /root/domain)
echo "$domaiin" > /root/domain
echo "$domaiin" > /root/yoloautosc/domain
echo "$tele_token" > /root/yoloautosc/tele_token.txt
echo "$tele_id" > /root/yoloautosc/tele_id.txt
echo "$clientname" > /root/yoloautosc/clientname.conf
clear

#gathering and saving server info
echo -e "\e[0;32mgathering & Saving Data Server...\e[0m"
servercountry=$(curl -sL ip.guide | jq -r '.location.country')
ispserver=$(curl -sL ip.guide | jq -r '.network.autonomous_system.organization')

echo "$srvrisp" >> /usr/local/etc/serverisp.txt
echo "$srvrcountry" >> /usr/local/etc/servercountry.txt
echo -e "\e[0;32mREADY FOR INSTALLATION SCRIPT...\e[0m"
echo -e ""
sleep 1

#Install SSH-VPN
echo -e "\e[0;32mINSTALLING SSH-VPN...\e[0m"
sleep 1
wget https://${Server_URL}/SETUP/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
echo -e "\e[0;32mDONE INSTALLING SSH-VPN\e[0m"
echo -e ""
sleep 1
#Install Xray
echo -e "\e[0;32mINSTALLING XRAY CORE...\e[0m"
sleep 1
wget https://${Server_URL}/SETUP/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
echo -e "\e[0;32mDONE INSTALLING XRAY CORE\e[0m"
echo -e ""
sleep 1
clear

#install ohp-server
echo -e "\e[0;32mINSTALLING OHP PORT...\e[0m"
sleep 1
wget https://${Server_URL}/SETUP/ohp.sh && chmod +x ohp.sh && ./ohp.sh
wget https://${Server_URL}/SETUP/ohp-dropbear.sh && chmod +x ohp-dropbear.sh && ./ohp-dropbear.sh
wget https://${Server_URL}/SETUP/ohp-ssh.sh && chmod +x ohp-ssh.sh && ./ohp-ssh.sh
echo -e "\e[0;32mDONE INSTALLING OHP PORT\e[0m"
clear

#install websocket
echo -e "\e[0;32mINSTALLING WEBSOCKET PORT...\e[0m"
wget https://${Server_URL}/SETUP/websocket-python/websocket.sh && chmod +x websocket.sh && screen -S websocket.sh ./websocket.sh
echo -e "\e[0;32mDONE INSTALLING WEBSOCKET PORT\e[0m"
clear

#Install SET-BR
echo -e "\e[0;32mINSTALLING SET-BR...\e[0m"
sleep 1
wget https://${Server_URL}/SETUP/set-br.sh && chmod +x set-br.sh && ./set-br.sh
echo -e "\e[0;32mDONE INSTALLING SET-BR...\e[0m"
echo -e ""
sleep 1
clear

rm -rf /usr/share/nginx/html/index.html
wget -q -O /usr/share/nginx/html/index.html "https://${Server_URL}/OTHERS/index.html"

# install server telegram auto update
cd /usr/bin/
#wget -O autocek_online "https://${Server_URL}/OTHERS/autocek_online.sh"
wget -O anti-highusage "https://${Server_URL}/BOT/anti-highusage.sh"
wget -O server_status "https://${Server_URL}/BOT/server_status.sh"
wget -O config_gen "https://${Server_URL}/BOT/config_gen.sh"

chmod +x anti-highusage
chmod +x server_status
chmod +x config_gen
cd

# / / setting cron
echo "0 6 * * * root reboot" >> /etc/crontab
echo "*/2 * * * * root /usr/bin/cleaner" >> /etc/crontab
echo "@hourly root /usr/bin/backup_tele" >> /etc/crontab
echo "*/2 * * * * root /usr/bin/anti-highusage" >> /etc/crontab #/ / Every 2 minute
echo "*/62 * * * * root /usr/bin/server_status" >> /etc/crontab # / / Every 62 Minutes

# Finish
rm -f /root/ins-xray.sh
rm -f /root/set-br.sh
rm -f /root/ssh-vpn.sh

# Version
echo "1.2" > /home/ver
clear
echo ""
echo ""
echo -e "    .-------------------------------------------."
echo -e "    |      Installation Has Been Completed      |"
echo -e "    '-------------------------------------------'"
echo ""
echo ""
echo -e "${purple}═════════════════════${NC}[-Autoscript-Lite-]${purple}═════════════════════${NC}" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    >>> Service Details <<<"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH & OpenVPN]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200"  | tee -a log-install.txt
echo "   - OpenVPN SSL             : 110"  | tee -a log-install.txt
echo "   - Stunnel4                : 222, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 143, 109"  | tee -a log-install.txt
echo "   - OHP Dropbear            : 8585"  | tee -a log-install.txt
echo "   - OHP SSH                 : 8686"  | tee -a log-install.txt
echo "   - OHP OpenVPN             : 8787"  | tee -a log-install.txt
echo "   - Websocket SSH(HTTP)     : 80"  | tee -a log-install.txt
echo "   - Websocket SSL(HTTPS)    : 443, 2096"  | tee -a log-install.txt
echo "   - Websocket OpenVPN       : 2097"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Sqd, Bdvp, Ngnx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8000 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   [ XRAY INFORMATION ]" | tee -a log-install.txt
echo -e "${purple}   --------------------${NC}" | tee -a log-install.txt
echo "   - XRAY VLESS WS TLS          : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS TCP XPRX VISION : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS WS None TLS     : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   [ YAML INFORMATION ]" | tee -a log-install.txt
echo -e "${purple}   --------------------${NC}" | tee -a log-install.txt
echo "   - YAML XRAY VLESS WS"  | tee -a log-install.txt
echo "   - YAML XRAY VLESS XTLS"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   [ SERVER INFORMATION ]"  | tee -a log-install.txt
echo -e "${purple}   ----------------------${NC}" | tee -a log-install.txt
echo "   - Timezone                : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPV6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 06.00 GMT +8" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   [ DEV INFORMATION ]" | tee -a log-install.txt
echo -e "${purple}   -------------------${NC}" | tee -a log-install.txt
echo "   - Autoscript-Lite By      : YoLoNET"  | tee -a log-install.txt
echo "   - Telegram                : t.me/rayyolo"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo -e "${purple}════════════════${NC}Autoscript-Lite By YoLoNET${purple}════════════════${NC}" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo ""
echo -e "Thanks For Installing This Autoscript-Lite :)"
echo -e "VPS Will Reboot . . ."
sleep 3
rm -r setup-lite.sh
reboot
