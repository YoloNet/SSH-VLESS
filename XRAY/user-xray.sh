#!/bin/bash
#Autoscript-Lite By YoLoNET
clear
MYIP=$(wget -qO- ipv4.icanhazip.com)
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/config.json")

if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\\E[0;41;36m    Check XRAY XTLS Config     \E[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo "You have no existing clients!"
    clear
    exit 1
fi

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\\E[0;41;36m    Check XRAY XTLS Config     \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo " Select the existing client to view the config"
echo " Press CTRL+C to return"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " No  Expired         User          Days Left"
i=1

while [[ $i -le $NUMBER_OF_CLIENTS ]]; do
    user=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${i}"p)
    exp=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${i}"p)
    days_left=$(( ( $(date -d "$exp" +%s) - $(date -d "today" +%s) ) / 86400 ))

    printf "%2d  %-15s %-15s %d\n" $i "$exp" "$user" $days_left
    i=$((i + 1))
done

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
        if [[ ${CLIENT_NUMBER} == '1' ]]; then
            read -rp "Select one client [1] (or 'x' to return to menu-ws): " CLIENT_NUMBER
            if [[ "${CLIENT_NUMBER}" == "x" ]]; then
                return  # Go back to the calling function
            fi
        else
            echo -e ""
            read -rp "Select one client [1-${NUMBER_OF_CLIENTS}] 
(or 'x' to return to menu): " CLIENT_NUMBER
            if [[ "${CLIENT_NUMBER}" == "x" ]]; then
                menu-xray
            fi
        fi
    done
# The rest of your script here
clear
echo ""
read -p "Bug Address (Example: www.google.com) : " address
read -p "Bug SNI/Host (Example : m.facebook.com) : " hst
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

user=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
xtls="$(cat ~/log-install.txt | grep -w "VLESS TCP XTLS" | cut -d: -f2|sed 's/ //g')"
domain=$(cat /root/yoloautosc/domain)
uuid=$(grep "},{" /usr/local/etc/xray/config.json | cut -b 11-46 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
hariini=`date -d "0 days" +"%Y-%m-%d"`
vless_direct1="vless://${uuid}@${sts}${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=${sni}#XRAY_VLESS_DIRECT_$user"
vless_direct2="vless://${uuid}@${sts}${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct-udp443&sni=${sni}#XRAY_VLESS_DIRECTUDP443_$user"
vless_splice3="vless://${uuid}@${sts}${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=${sni}#XRAY_VLESS_SPLICE_$user"
vless_splice4="vless://${uuid}@${sts}${domain}:${xtls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice-udp443&sni=${sni}#XRAY_VLESS_SPLICEUDP443_$user"
clear
echo -e ""
echo -e "════════════[XRAY VLESS TCP XTLS]════════════"
echo -e "Remarks              : ${user}"
echo -e "Domain               : ${domain}"
echo -e "ID                   : ${uuid}"
echo -e "Port Direct          : ${xtls}"
echo -e "Port Splice          : ${xtls}"
echo -e "Encryption           : None"
echo -e "Network              : TCP"
echo -e "Security             : XTLS"
echo -e "Flow                 : Direct & Splice"
echo -e "AllowInsecure        : True/Allow"
echo -e "═════════════════════════════════════════════"
echo -e "Link Direct          : ${vless_direct1}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Direct UDP 443  : ${vless_direct2}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Splice          : ${vless_splice3}"
echo -e "═════════════════════════════════════════════"
echo -e "Link Splice UDP 443  : ${vless_splice4}"
echo -e "═════════════════════════════════════════════"
echo -e "YAML Direct          : http://${MYIP}:81/$user-VLESSDIRECT.yaml"
echo -e "═════════════════════════════════════════════"
echo -e "YAML Splice          : http://${MYIP}:81/$user-VLESSSPLICE.yaml"
echo -e "═════════════════════════════════════════════"
echo -e "Created On           : $hariini"
echo -e "Expired On           : $exp"
echo -e "═════════════════════════════════════════════"
echo -e ""
echo -e "Autoscript By YoLoNET"
echo -e ""
