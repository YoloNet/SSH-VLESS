#!/bin/bash
#Autoscript-Lite By YoLoNET
clear
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
/etc/init.d/openvpn restart
systemctl restart --now openvpn-server@server-tcp-1194
systemctl restart --now openvpn-server@server-udp-2200
/etc/init.d/fail2ban restart
/etc/init.d/cron restart
/etc/init.d/nginx restart
/etc/init.d/squid restart
systemctl restart xray.service
systemctl restart xray@vless.service
systemctl restart xray@none.service
systemctl restart xray@xtls.service
systemctl restart ws-http
systemctl restart ws-https
systemctl restart ohp
systemctl restart ohpd
systemctl restart ohps
systemctl restart cdn-dropbear
systemctl restart cdn-ovpn
systemctl restart cdn-ssl
systemctl restart client-sldns
systemctl restart server-sldns
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m       All Services Restarted      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 1
clear