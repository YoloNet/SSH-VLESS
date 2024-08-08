#!/bin/bash
#Autoscript-Lite By YoLoNET
clear
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'

domain=$(cat /root/yoloautosc/domain)
MYIP=$(wget -qO- ipv4.icanhazip.com);
xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS TCP XPRX VISION" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\E[0;41;36m  Add XRAY Vless TCP xprx Account  \E[0m"
        echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
		    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\E[0;41;36m  Add XRAY Vless TCP xprx Account  \E[0m"
            echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			read -n 1 -s -r -p "Press any key to back on menu"
			menu
		fi
	done

read -p "Bug Address (Example: www.google.com) : " address
read -p "Bug SNI/Host (Example : m.facebook.com) : " hst
read -p "Expired (days) : " masaaktif
bug_addr=${address}.
bug_addr2=${address}
if [[ $address == "" ]]; then
sts=$bug_addr2
else
sts=$bug_addr
fi
bug=${hst}
bug2=bug.com
if [[ $hst == "" ]]; then
sni=$bug2
else
sni=$bug
fi

uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Input To Server
sed -i '/#xtls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","flow": "xtls-rprx-vision","email": "'""$user""'"' /usr/local/etc/xray/config.json

vless_direct1="vless://${uuid}@${sts}${domain}:${xtls}?security=xprx&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-vision&sni=${sni}#XTLS-rprx-vision_$user"

# // Restarting Service
systemctl restart xray
systemctl restart xray@config
systemctl restart xray@vless
systemctl restart xray@none
service cron restart

clear
echo -e ""
echo -e "════════════[XRAY VLESS TCP xprx]════════════"
echo -e "Remarks              : ${user}"
echo -e "Domain               : ${domain}"
echo -e "ID                   : ${uuid}"
echo -e "Port Direct          : ${xtls}"
echo -e "Port Splice          : ${xtls}"
echo -e "Encryption           : None"
echo -e "Network              : TCP"
echo -e "Security             : xprx"
echo -e "Flow                 : Direct & Splice"
echo -e "AllowInsecure        : True/Allow"
echo -e "═════════════════════════════════════════════"
echo -e "Link Direct          : ${vless_direct1}"
echo -e "═════════════════════════════════════════════"
echo -e "═════════════════════════════════════════════"
echo -e "Created On           : $hariini"
echo -e "Expired On           : $exp"
echo -e "═════════════════════════════════════════════"
echo -e ""
echo -e "Autoscript By YoLoNET"
echo -e ""
