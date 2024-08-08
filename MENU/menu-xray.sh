#!/bin/bash
#Autoscript-Lite By Visntech Modded by YoLoNET
#modded by yolonet

#get server date
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
purple='\e[0;35m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }


clear
domain=$(cat /root/yoloautosc/domain)
#headerdesign
servercountry=$(curl -sL ip.guide | jq -r '.location.country')
ispserver=$(curl -sL ip.guide | jq -r '.network.autonomous_system.organization')
namaklien=$(cat /root/yoloautosc/clientname.conf)
xversion=$(xray version | head -n 1 | awk '{print $2}')
osversion=$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)

clear
# // nginx status
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // xray status
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

# TOTAL ACC CREATE VMESS WS
# TOTAL ACC CREATE  VLESS WS
totalvless=$(grep -c -E "^### " "/usr/local/etc/xray/vless.json")
# TOTAL ACC CREATE  VLESS TCP XTLS
totalxtls=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")
### MENU START DI BAWAH ##
clear
# Call the count user online function
#useronvmess=$(check_online_users_vmess)
#useronxtls=$(check_online_users_xtls)
#useronvless=$(check_online_users_vless)

clear
echo -e "$red$KEPALA"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                    SERVER INFO                     \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s icanhazip.com/ip )
if [ "$cekup" = "day" ]; then
echo -e " System Uptime   :  $uphours $upminutes $uptimecek"
else
echo -e " System Uptime   :  $uphours $upminutes"
fi
echo -e " Memory Usage    :  $uram / $tram"
echo -e " VPN Core        :  XRAY-CORE"
echo -e " Domain          :  $domain"
echo -e " Server Location :  $servercountry"
echo -e " Server ISP      :  $ispserver"
echo -e " IP VPS          :  $IPVPS"
echo -e " XRAY Version    :  $xversion"
echo -e " OS VERSION      :  $osversion"
 
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e "     [ XRAY-CORE${NC} : ${status_xray} ]   [ NGINX${NC} : ${status_nginx} ]"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
echo -e " Total User      :vless=$totalvless   | XTLS = $totalxtls " 
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                     XRAY MENU                      \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m
 [\033[1;36m•1 \033[0m] Vless WS Panel    [\033[1;36m•2 \033[0m]  Vless TCP XTLS Panel"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                       SYSTEM                       \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m
 [\033[1;36m•3 \033[0m] Change Domain     [\033[1;36m•6\033[0m]  Check VPN Port
 [\033[1;36m•4 \033[0m] Renew Certificate [\033[1;36m•7\033[0m]  Restart VPN Services
 [\033[1;36m•5 \033[0m] Check VPN Status  [\033[1;36m•8\033[0m]  Config Generator"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                  OTHER FUNCTION                    \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m
 [\033[1;36m•9\033[0m]   Speedtest VPS    [\033[1;36m•12\033[0m]  DNS Changer
 [\033[1;36m•10\033[0m]  Check RAM        [\033[1;36m•13\033[0m]  Netflix Checker
 [\033[1;36m•11\033[0m]  Check Bandwith   [\033[1;36m•14\033[0m]  Set Bug Telco
 [\033[1;36m•77\033[0m]  System Menu"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                  BACKUP FUNCTION                   \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m
 [\033[1;36m•15\033[0m]  Backup To Telegram Bot
 [\033[1;36m•16\033[0m]  Restore From Telegram Bot"
echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;46m                    SCRIPT INFO                     \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
echo -e "\e[94m╔════════════════════════════════════════════════════╗\e[0m"
echo -e "\e[94m║\e[1m        \e[93mVLESS Websocket+XTLS VISION+ANYPATH     \e[0m\e[94m║\e[0m"
echo -e "\e[94m║\e[1m  \e[93m           Autoscript By:\e[0m YOLONET                 \e[94m║\e[0m"
echo -e "\e[94m║\e[1m  \e[93m            Expiry Script: \e[92mLifetime\e[0m               \e[94m║\e[0m"
echo -e "\e[94m║\e[1m  \e[93m               Owner: \e[96m@rayyolo\e[0m                    \e[94m║\e[0m"
echo -e "\e[94m╚════════════════════════════════════════════════════╝\e[0m"
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo -e ""
echo -ne "Select menu : "; read x
if [[ $(cat /opt/.ver) = $serverV ]] > /dev/null 2>&1; then
    if [[ $x -eq 1 ]]; then
       menu-vless
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 2 ]]; then
       menu-xray
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 3 ]]; then
       add-host
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 4 ]]; then
       certxray
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 5 ]]; then
       status
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 6 ]]; then
       info
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 7 ]]; then
       restart
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 8 ]]; then
       config_gen
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 9 ]]; then
       speedtest
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 10 ]]; then
       ram
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 11 ]]; then
       vnstat
       echo ""
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 12 ]]; then
       clear
       dns
           echo ""
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 13 ]]; then
       clear
       bash <(curl -L -s https://git.io/JRw8R) -E
           echo ""
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 14 ]]; then
       clear
       kumbang
           echo ""
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 15 ]]; then
       backup_tele
           echo ""
       menu
    elif [[ $x -eq 16 ]]; then
       clear
       restore_tele
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 17 ]]; then
      menu
      read -n1 -r -p "Press any key to continue..."
      menu
    elif [[ $x -eq 77 ]]; then
      system-menu
      read -n1 -r -p "Press any key to continue..."
      menu
    elif [[ $x -eq 18 ]]; then
       menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 19 ]]; then
       menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 101 ]]; then
       config_gen
       read -n1 -r -p "Press any key to continue..."
       menu   
    else
       menu
    fi
fi
