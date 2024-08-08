#!/bin/bash
# SSH-VPN Installation Setup
# By YoLoNET
# ==================================

red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

Server_URL="$(cat /root/install_link.txt )"

#get server date for today
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo "Checking VPS"
clear

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#Detail
country="MY"
state="Sabah"
locality="Parit Buntar"
organization="YoLoNET-Project"
organizationalunit="YoLoNET-Project"
commonname="YoLoNET-Project"
email="rayyoloproject@gmail.com"

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install netfilter-persistent
apt-get install netfilter-persistent

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "menu" >> .profile

# install webserver
apt -y install nginx
mkdir -p /home/vps/public_html
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://${Server_URL}/OTHERS/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://${Server_URL}/OTHERS/vps.conf"
# wget -O /etc/nginx/conf.d/xray.conf "https://${Server_URL}/OTHERS/xray.conf" // no need. this sc use fallback now

/etc/init.d/nginx restart
# // install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://${Server_URL}/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# // setting port ssh
cd
apt-get -y update
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'

# /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

# // install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 68 -p 69 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# // install squid for debian 9,10 & ubuntu 20.04
apt -y install squid3

# install squid for debian 11
apt -y install squid
wget -O /etc/squid/squid.conf "https://${Server_URL}/SSHWS-SETUP/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat / latest
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.12.tar.gz
tar zxvf vnstat-2.12.tar.gz
cd vnstat-2.12
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.12.tar.gz
rm -rf /root/vnstat-2.12

# // install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 777
connect = 127.0.0.1:109

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[kontol-stunnel]
accept = 2096
connect = 127.0.0.1:2091
END

# // make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# // konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/lib/systemd/systemd-sysv-install enable stunnel4
systemctl start stunnel4
/etc/init.d/stunnel4 restart

# // OpenVPN
wget https://${Server_URL}/SSHWS-SETUP/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -q -O /etc/issue.net "https://${Server_URL}/OTHERS/issues.net" && chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# install resolvconf service
apt install resolvconf -y

#start resolvconf service
systemctl start resolvconf.service
systemctl enable resolvconf.service
touch /etc/resolvconf/resolv.conf.d/head
echo nameserver 1.1.1.1 >> /etc/resolvconf/resolv.conf.d/head
echo nameserver 1.0.0.1 >> /etc/resolvconf/resolv.conf.d/head
resolvconf --enable-updates
resolvconf -u
systemctl restart resolvconf.service

# download script
cd /usr/bin
wget -O add-ssh "https://${Server_URL}/MENU/sshovpn/add-ssh.sh"
wget -O trial "https://${Server_URL}/MENU/sshovpn/trial-ssh.sh"
wget -O del-ssh "https://${Server_URL}/MENU/sshovpn/del-ssh.sh"
wget -O delete "https://${Server_URL}/MENU/sshovpn/delete.sh"
wget -O member "https://${Server_URL}/MENU/sshovpn/member.sh"
wget -O cek-ssh "https://${Server_URL}/MENU/sshovpn/cek-ssh.sh"
wget -O ceklim "https://${Server_URL}/MENU/sshovpn/ceklim.sh"
wget -O renew-ssh "https://${Server_URL}/MENU/sshovpn/renew-ssh.sh"
wget -O autokill "hhttps://${Server_URL}/MENU/sshovpn/autokill.sh"
wget -O tendang "https://${Server_URL}/MENU/sshovpn/tendang.sh"
wget -O port-ovpn "https://${Server_URL}/change-port/port-ovpn.sh"
wget -O port-ssl "https://${Server_URL}/change-port//port-ssl.sh"
wget -O port-squid "https://${Server_URL}/change-port/port-squid.sh"
wget -O port-websocket "https://${Server_URL}/change-port/port-websocket.sh"
wget -O port-ohp "https://${Server_URL}/change-port/port-ohp.sh"
wget -O wbmn "https://${Server_URL}/MENU/sshovpn/webmin.sh"
wget -O user-list "https://${Server_URL}/MENU/sshovpn/user-list.sh"
wget -O user-lock "https://${Server_URL}/MENU/sshovpn/user-lock.sh"
wget -O user-unlock "https://${Server_URL}/MENU/sshovpn/user-unlock.sh"
wget -O user-password "https://${Server_URL}/MENU/sshovpn/user-password.sh"
wget -O clear-log "https://${Server_URL}/MENU/sshovpn/clear-log.sh"
wget -O menu-ssh "https://${Server_URL}/MENU/sshovpn/menu-ssh.sh"
wget -O add-host "https://${Server_URL}/SSH/add-host.sh"
wget -O speedtest "https://${Server_URL}/OTHERS/speedtest_cli.py"
wget -O xp "https://${Server_URL}/SSH/xp.sh"
wget -O menu "https://${Server_URL}/MENU/menu.sh"
wget -O status "https://${Server_URL}/SSH/status.sh"
wget -O info "https://${Server_URL}/SSH/info.sh"
wget -O restart "https://${Server_URL}/SSH/restart.sh"
wget -O ram "https://${Server_URL}/SSH/ram.sh"
wget -O dns "https://${Server_URL}/SSH/dns.sh"
wget -O system-menu "https://${Server_URL}/MENU/system-menu.sh"
wget -O updater_sc "https://${Server_URL}/SETUP/updater_sc.sh"
wget -O nf "https://github.com/sjlleo/netflix-verify/releases/download/2.61/nf_2.61_linux_amd64"
chmod +x menu
chmod +x add-host
chmod +x speedtest
chmod +x xp
chmod +x status
chmod +x info
chmod +x restart
chmod +x ram
chmod +x dns
chmod +x system-menu
chmod +x updater_sc
chmod +x nf
chmod +x add-ssh
chmod +x trial
chmod +x del-ssh
chmod +x delete
chmod +x member
chmod +x cek-ssh
chmod +x ceklim
chmod +x renew-ssh
chmod +x autokill
chmod +x tendang
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-squid
chmod +x port-websocket
chmod +x port-ohp
chmod +x wbmn
chmod +x user-list
chmod +x user-lock
chmod +x user-unlock
chmod +x user-password
chmod +x clear-log
chmod +x menu-ssh

cd
# adding ssh auto remove expired user

echo "0 1 * * * root delete" >> /etc/crontab
echo "0 2 * * * root xp" >> /etc/crontab
echo "0 8 * * * root clear-log" >> /etc/crontab
echo "0 3 * * * root /usr/bin/xp" >> /etc/crontab
echo "0 4 * * * root /usr/bin/delete" >> /etc/crontab
echo "0 9 * * * root /usr/bin/clear-log" >> /etc/crontab
# restart service vron
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y

# finishing
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
/etc/init.d/stunnel4 restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

clear
