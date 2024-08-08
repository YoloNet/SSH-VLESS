#wget https://github.com/${GitUser}/

#IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
echo -e "\e[32mloading...\e[0m"
clear
# Valid Script


clear
MYIP=$(wget -qO- icanhazip.com);
domain=$(cat /usr/local/etc/xray/domain)
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn3="$(cat ~/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2|sed 's/ //g')"
ovpn4="$(cat ~/log-install.txt | grep -w "OpenVPN SSL" | cut -d: -f2|sed 's/ //g')"
echo -e "\e[1;36m.-----------------------------------------.\e[0m"
echo -e "\e[1;36m|            \e[1;33mCHANGE PORT OPENVPN\e[m          \e[1;36m|\e[0m"
echo -e "\e[1;36m'-----------------------------------------'\e[0m"
echo -e " \e[0;32m>>\e[0m\e[1;35mChange Port For OpenVPN:\e[0m"
echo -e "     [1]  Change Port TCP $ovpn"
echo -e "     [2]  Change Port UDP $ovpn2"
echo -e "     [3]  Change Port OHP $ovpn3"
echo -e "     [4]  Change Port SSL $ovpn4"
echo -e "======================================"
echo -e "     [x]  Back To Menu Change Port"
echo -e "     [y]  Go To Main Menu"
echo -e ""
read -p "     Select From Options [1-4 or x & y] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-tcp-$ovpn.conf
rm -f /etc/openvpn/client-tcp-$ovpn.ovpn
rm -f /home/vps/public_html/client-tcp-$ovpn.ovpn
cat > /etc/openvpn/server/server-tcp-$vpn.conf<<END
port $vpn
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.6.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-tcp.log
verb 3
END
cat > /etc/openvpn/client-tcp-$vpn.ovpn <<-END
setenv FRIENDLY_NAME "OVPN TCP"
client
dev tun
proto tcp
remote $domain 1194
http-proxy $MYIP 8000
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/client-tcp-$vpn.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-$vpn.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-$vpn.ovpn
cp /etc/openvpn/client-tcp-$vpn.ovpn /home/vps/public_html/client-tcp-$vpn.ovpn
systemctl disable --now openvpn-server@server-tcp-$ovpn > /dev/null
systemctl enable --now openvpn-server@server-tcp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2/   - OpenVPN                 : TCP $vpn, UDP $ovpn2/g" /root/log-install.txt
sed -i "s/$ovpn/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo -e "\e[1;31mPort $vpn is used\e[0m"
fi
;;
2)
read -p "New Port OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/server/server-udp-$ovpn2.conf
rm -f /etc/openvpn/client-udp-$ovpn2.ovpn
rm -f /home/vps/public_html/client-tcp-$ovpn2.ovpn
cat > /etc/openvpn/server/server-udp-$vpn.conf<<END
port $vpn
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.7.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-udp.log
verb 3
explicit-exit-notify
END
cat > /etc/openvpn/client-udp-$vpn.ovpn <<-END
setenv FRIENDLY_NAME "OVPN UDP"
client
dev tun
proto udp
remote $domain 2200
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/client-udp-$vpn.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-$vpn.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-$vpn.ovpn
cp /etc/openvpn/client-udp-$vpn.ovpn /home/vps/public_html/client-udp-$vpn.ovpn
systemctl disable --now openvpn-server@server-udp-$ovpn2 > /dev/null
systemctl enable --now openvpn-server@server-udp-$vpn > /dev/null
sed -i "s/   - OpenVPN                 : TCP $ovpn, UDP $ovpn2/   - OpenVPN                 : TCP $ovpn, UDP $vpn/g" /root/log-install.txt
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo -e "\e[1;31mPort $vpn is used\e[0m"
fi
;;
3)
read -p "New Port OHP OpenVPN: " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /home/vps/public_html/client-tcp-ohp1194.ovpn
rm -f /etc/systemd/system/ohp.service
cat > /etc/openvpn/client-tcp-ohp1194.ovpn <<END
client
dev tun
proto tcp
remote "bug.com" 1194
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

setenv FRIENDLY_NAME "OVPN OHP"
http-proxy $MYIP $vpn
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host bug.com
http-proxy-option CUSTOM-HEADER X-Online-Host bug.com
http-proxy-option CUSTOM-HEADER X-Forward-Host bug.com
http-proxy-option CUSTOM-HEADER Connection: keep-alive
END
#Buat Service Untuk OHP Ovpn
cat > /etc/systemd/system/ohp.service <<END
[Unit]
Description=Direct Squid Proxy For OpenVPN TCP
Documentation=https://t.me/redvpn121
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohp -port $vpn -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END
echo '<ca>' >> /etc/openvpn/client-tcp-ohp1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ohp1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ohp1194.ovpn
cp /etc/openvpn/client-tcp-ohp1194.ovpn /home/vps/public_html/client-tcp-ohp1194.ovpn
systemctl daemon-reload
systemctl enable ohp
systemctl restart ohp
sed -i "s/   - OHP OpenVPN             : $ovpn3/   - OHP OpenVPN             : $vpn/g" /root/log-install.txt
sed -i "s/$ovpn3/$vpn/g" /etc/stunnel/stunnel.conf
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo -e "\e[1;31mPort OHP OpenVPN $vpn is used\e[0m"
fi
;;
4)
read -p "New Port OpenVPN SSL : " vpn
if [ -z $vpn ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $vpn)
if [[ -z $cek ]]; then
rm -f /etc/openvpn/client-tcp-ssl.ovpn
rm -f /home/vps/public_html/client-tcp-ssl.ovpn
cat > /etc/openvpn/client-tcp-ssl.ovpn <<-END
setenv FRIENDLY_NAME "OVPN SSL"
client
dev tun
proto tcp
remote $domain $vpn
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
echo '<ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ssl.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
# Copy config OpenVPN client ke home directory root agar mudah didownload ( SSL )
cp /etc/openvpn/client-tcp-ssl.ovpn /home/vps/public_html/client-tcp-ssl.ovpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart
sed -i "s/   - OpenVPN SSL             : $ovpn4/   - OpenVPN SSL             : $vpn/g" /root/log-install.txt
sed -i "s/$ovpn4/$vpn/g" /etc/stunnel/stunnel.conf
/etc/init.d/stunnel4 restart > /dev/null
echo -e "\e[032;1mPort $vpn modified successfully\e[0m"
else
echo -e "\e[1;31mPort OpenVPN SSL $vpn is used\e[0m"
fi
;;
x)
clear
change-port
;;
y)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac
