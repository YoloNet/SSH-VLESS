#wget https://github.com/${GitUser}/

#Direct Proxy Squid For OpenVPN TCP
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- https://icanhazip.com);
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
MYIP2="s/xxxxxxxxx/$MYIP/g";

#Update Repository VPS
clear
apt update 
apt-get -y upgrade

#Port Server ovpn ohp
#Jika Ingiin Mengubah Port Silahkan Sesuaikan Dengan Port Yang Ada Di VPS Mu
Port_OpenVPN_TCP='22';
Port_Squid='3128';
Port_OHP='8686';
Server_URL="$(cat /root/install_link.txt )"
#Installing ohp Server
cd 
wget -O /usr/local/bin/ohps "https://${Server_URL}/SETUP/ohps"
chmod +x /usr/local/bin/ohps

#Buat Service Untuk OHP SSH
cat > /etc/systemd/system/ohps.service <<END
[Unit]
Description=Direct Squid Proxy For open-ssh
Documentation=https://t.me/redvpn121
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohp -port 8686 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:22
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ohps
systemctl restart ohps
echo ""
echo -e "${GREEN}Done Installing OHP OpenSSH${NC}"
echo -e "Port OHP OpenSSH: $ohpp"

