#!/bin/bash
#wget https://github.com/${GitUser}/


# // IZIN SCRIPT
export MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
echo -e "\e[32mloading...\e[0m"
clear
echo -e "\e[32mloading...\e[0m"
clear

# // PROVIDED
export creditt=$(cat /root/provided)

# // TEXT ON BOX COLOUR
export box=$(cat /etc/box)

# // LINE COLOUR
export line=$(cat /etc/line)

# // BACKGROUND TEXT COLOUR
export back_text=$(cat /etc/back)

clear
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
echo -e   "  \e[$back_text           \e[30m[\e[$box CREATE USER SSH & OPENVPN\e[30m ]\e[1m               \e[m"
echo -e   "  \e[$line═══════════════════════════════════════════════════════\e[m"
read -p "   Username : " Login
read -p "   Password : " Pass
read -p "   Bug SNI/Host (Example : m.facebook.com) : " sni
read -p "   Expired (days): " masaaktif

IP=$(wget -qO- icanhazip.com);
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /usr/local/etc/xray/domain)
else
domain=$IP
fi

export ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
export sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
export ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
export ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
export ovpn3="$(cat ~/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2|sed 's/ //g')"
export ovpn4="$(cat ~/log-install.txt | grep -w "OpenVPN SSL" | cut -d: -f2|sed 's/ //g')"
export ohpssh="$(cat ~/log-install.txt | grep -w "OHP SSH" | cut -d: -f2|sed 's/ //g')"
export ohpdrop="$(cat ~/log-install.txt | grep -w "OHP Dropbear" | cut -d: -f2|sed 's/ //g')"
export wsdropbear="$(cat ~/log-install.txt | grep -w "Websocket SSH(HTTP)" | cut -d: -f2|sed 's/ //g')"
export wsstunnel="$(cat ~/log-install.txt | grep -w "Websocket SSL(HTTPS)" | cut -d: -f2|sed 's/ //g')"
export wsovpn="$(cat ~/log-install.txt | grep -w "Websocket OpenVPN" | cut -d: -f2|sed 's/ //g')"
nsdomain1=$(cat /root/nsdomain)
pubkey1=$(cat /etc/slowdns/server.pub)

sleep 1
echo Ping Host
echo Check Acces...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Create Acc: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear

# // DATE
export harini=`date -d "0 days" +"%Y-%m-%d"`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
export exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
export exp1=`date -d "$masaaktif days" +"%Y-%m-%d"`

cat > /home/vps/public_html/ssh-$Login.txt <<-END
====================================================================
             P R O J E C T  O F  N E V E R M O R E S S H
                       [Freedom Internet]
====================================================================
            https://github.com/yolonet/sapphire
====================================================================
              Format SSH OVPN Account - SPv2
====================================================================

====================================================================
Premium Account SSH & OpenVPN
====================================================================
Username         : $Login
Password         : $Pass
Created          : $harini
Expired          : $exp1
====================================================================
Domain           : $domain
Name Server(NS)  : $nsdomain1
Pubkey           : $pubkey1
IP/Host          : $MYIP
OpenSSH          : 22
Dropbear         : 143, 109
SSL/TLS          :$ssl
SlowDNS          : 22,80,443,53,5300
SSH-UDP          : 1-65535
WS SSH(HTTP)     : $wsdropbear
WS SSL(HTTPS)    : $wsstunnel
WS OpenVPN(HTTP) : $wsovpn
OHP Dropbear     : $ohpdrop
OHP OpenSSH      : $ohpssh
OHP OpenVPN      : $ovpn3
Port Squid       :$sqd
Badvpn(UDPGW)    : 7100-7300
====================================================================
CONFIG SSH WS
SSH 22      : $(cat /usr/local/etc/xray/domain):22@$Login:$Pass
SSH 80      : $(cat /usr/local/etc/xray/domain):80@$Login:$Pass
SSH 443     : $(cat /usr/local/etc/xray/domain):443@$Login:$Pass
SSH 1-65535 : $(cat /usr/local/etc/xray/domain):1-65535@$Login:$Pass
====================================================================
CONFIG OPENVPN
OpenVPN TCP : $ovpn http://$MYIP:81/client-tcp-$ovpn.ovpn
OpenVPN UDP : $ovpn2 http://$MYIP:81/client-udp-$ovpn2.ovpn
OpenVPN SSL : $ovpn4 http://$MYIP:81/client-tcp-ssl.ovpn
OpenVPN OHP : $ovpn3 http://$MYIP:81/client-tcp-ohp1194.ovpn
====================================================================
PAYLOAD WS       : GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
====================================================================
PAYLOAD WSS      : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
====================================================================
PAYLOAD WS OVPN  : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
====================================================================

END

echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "\e[$back_text         \e[30m[\e[$box Premium Account SSH & OpenVPN\e[30m ]\e[1m           \e[m"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "Username         : $Login"
echo -e "Password         : $Pass"
echo -e "Created          : $harini"
echo -e "Expired          : $exp1"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "Domain           : $domain"
echo -e "Name Server(NS)  : $nsdomain1"
echo -e "Pubkey           : $pubkey1"
echo -e "IP/Host          : $MYIP"
echo -e "OpenSSH          : 22"
echo -e "Dropbear         : 143, 109"
echo -e "SSL/TLS          :$ssl"
echo -e "SlowDNS          : 22,80,443,53,5300"
echo -e "SSH-UDP          : 1-65535"
echo -e "WS SSH(HTTP)     : $wsdropbear"
echo -e "WS SSL(HTTPS)    : $wsstunnel"
echo -e "WS OpenVPN(HTTP) : $wsovpn"
echo -e "OHP Dropbear     : $ohpdrop"
echo -e "OHP OpenSSH      : $ohpssh"
echo -e "OHP OpenVPN      : $ovpn3"
echo -e "Port Squid       :$sqd"
echo -e "Badvpn(UDPGW)    : 7100-7300"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "CONFIG SSH WS"
echo -e "SSH Config  : http://${domain}:81/ssh-$Login.txt"
echo -e "SSH 22      : $(cat /usr/local/etc/xray/domain):22@$Login:$Pass"
echo -e "SSH 80      : $(cat /usr/local/etc/xray/domain):80@$Login:$Pass"
echo -e "SSH 443     : $(cat /usr/local/etc/xray/domain):443@$Login:$Pass"
echo -e "SSH 1-65535 : $(cat /usr/local/etc/xray/domain):1-65535@$Login:$Pass"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "CONFIG OPENVPN"
echo -e "--------------"
echo -e "OpenVPN TCP : $ovpn http://$MYIP:81/client-tcp-$ovpn.ovpn"
echo -e "OpenVPN UDP : $ovpn2 http://$MYIP:81/client-udp-$ovpn2.ovpn"
echo -e "OpenVPN SSL : $ovpn4 http://$MYIP:81/client-tcp-ssl.ovpn"
echo -e "OpenVPN OHP : $ovpn3 http://$MYIP:81/client-tcp-ohp1194.ovpn"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "PAYLOAD WS       : GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "PAYLOAD WSS      : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo -e "PAYLOAD WS OVPN  : GET wss://$sni/ HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]"
echo -e "\e[$line═══════════════════════════════════════════════════════\e[m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu SSH"
ssh2
