# ==================================================
#wget https://github.com/${GitUser}/


# // initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP=$(curl -s ipinfo.io/ip )
MYIP=$(curl -sS ipv4.icanhazip.com)
MYIP=$(curl -sS ifconfig.me )
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# // detail nama perusahaan
country="MY"
state="Kuala_Lumpur"
locality="Kuala_Lumpur"
organization="@todfix667"
organizationalunit="@todfix667"
commonname="Reddvpn"
email="admin@Reddvpn.com"

# // simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/${GitUser}/sapphire/main/password"
chmod +x /etc/pam.d/common-password

# // go to root
cd

# // Edit file /etc/systemd/system/rc-local.service
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

# // nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# // Ubah izin akses
chmod +x /etc/rc.local

# // enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# // disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# // update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# // install wget and curl
apt -y install wget curl

# // set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# // set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# // install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "menu" >> .profile

# // install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/${GitUser}/sapphire/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/${GitUser}/sapphire/main/vps.conf"
/etc/init.d/nginx restart

# // install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/${GitUser}/sapphire/main/badvpn-udpgw64"
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
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/${GitUser}/sapphire/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# // setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://github.com/yolonet/addons/releases/download/vnstat-2.6/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

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
wget https://raw.githubusercontent.com/${GitUser}/sapphire/main/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# // install lolcat
wget https://raw.githubusercontent.com/${GitUser}/sapphire/main/lolcat.sh &&  chmod +x lolcat.sh && ./lolcat.sh

# // install fail2ban
apt -y install fail2ban

# // Instal DDOS Flate
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

# // banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/${GitUser}/sapphire/main/banner/bannerssh.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# // Bannerku menu
wget -O /usr/bin/bannerku https://raw.githubusercontent.com/${GitUser}/sapphire/main/banner/bannerku && chmod +x /usr/bin/bannerku

# // install bbr
wget https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/bbr.sh && chmod +x bbr.sh && ./bbr.sh

# // blockir torrent
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

# // download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/add-host.sh"
wget -O about "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/about.sh"
wget -O menu "https://raw.githubusercontent.com/${GitUser}/sapphire/main/menu.sh"
wget -O add-ssh "https://raw.githubusercontent.com/${GitUser}/sapphire/main/add-user/add-ssh.sh"
wget -O trial "https://raw.githubusercontent.com/${GitUser}/sapphire/main/add-user/trial.sh"
wget -O del-ssh "https://raw.githubusercontent.com/${GitUser}/sapphire/main/delete-user/del-ssh.sh"
wget -O member "https://raw.githubusercontent.com/${GitUser}/sapphire/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/${GitUser}/sapphire/main/delete-user/delete.sh"
wget -O cek-ssh "https://raw.githubusercontent.com/${GitUser}/sapphire/main/cek-user/cek-ssh.sh"
wget -O restart "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/info.sh"
wget -O ram "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/ram.sh"
wget -O renew-ssh "https://raw.githubusercontent.com/${GitUser}/sapphire/main/renew-user/renew-ssh.sh"
wget -O autokill "https://raw.githubusercontent.com/${GitUser}/sapphire/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/${GitUser}/sapphire/main/cek-user/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/${GitUser}/sapphire/main/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/${GitUser}/sapphire/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-ssl.sh"
wget -O port-squid "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-squid.sh"
wget -O port-websocket "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-websocket.sh"
wget -O wbmn "https://raw.githubusercontent.com/${GitUser}/sapphire/main/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/${GitUser}/sapphire/main/xp.sh"
wget -O xp2 "https://raw.githubusercontent.com/${GitUser}/sapphire/main/xp2.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/${GitUser}/sapphire/main/kernel.sh"
wget -O user-list "https://raw.githubusercontent.com/${GitUser}/sapphire/main/more-option/user-list.sh"
wget -O user-lock "https://raw.githubusercontent.com/${GitUser}/sapphire/main/more-option/user-lock.sh"
wget -O user-unlock "https://raw.githubusercontent.com/${GitUser}/sapphire/main/more-option/user-unlock.sh"
wget -O user-password "https://raw.githubusercontent.com/${GitUser}/sapphire/main/more-option/user-password.sh"
wget -O antitorrent "https://raw.githubusercontent.com/${GitUser}/sapphire/main/more-option/antitorrent.sh"
wget -O cfa "https://raw.githubusercontent.com/${GitUser}/sapphire/main/cloud/cfa.sh"
wget -O cfd "https://raw.githubusercontent.com/${GitUser}/sapphire/main/cloud/cfd.sh"
wget -O cfp "https://raw.githubusercontent.com/${GitUser}/sapphire/main/cloud/cfp.sh"
wget -O swap "https://raw.githubusercontent.com/${GitUser}/sapphire/main/swapkvm.sh"
wget -O check-sc "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/running.sh"
wget -O ssh2 "https://raw.githubusercontent.com/${GitUser}/sapphire/main/menu/ssh2.sh"
wget -O autoreboot "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/autoreboot.sh"
wget -O bbr "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/bbr.sh"
wget -O port-ohp "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-ohp.sh"
wget -O port-xray "https://raw.githubusercontent.com/${GitUser}/sapphire/main/change-port/port-xray.sh"
wget -O panel-domain "https://raw.githubusercontent.com/${GitUser}/sapphire/main/menu/panel-domain.sh"
wget -O system "https://raw.githubusercontent.com/${GitUser}/sapphire/main/menu/system.sh"
wget -O themes "https://raw.githubusercontent.com/${GitUser}/sapphire/main/menu/themes.sh"
wget -O update "https://raw.githubusercontent.com/${GitUser}/sapphire/main/update/update.sh"
wget -O run-update "https://raw.githubusercontent.com/${GitUser}/sapphire/main/update/run-update.sh"
wget -O message-ssh "https://raw.githubusercontent.com/${GitUser}/sapphire/main/update/message-ssh.sh"
wget -O nf "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/nf.sh"
wget -O dns "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/dns.sh"
wget -O netf "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/netf.sh"
wget -O ins-helium "https://raw.githubusercontent.com/${GitUser}/sapphire/main/system/ins-helium.sh"
chmod +x add-host
chmod +x menu
chmod +x add-ssh
chmod +x trial
chmod +x del-ssh
chmod +x member
chmod +x delete
chmod +x cek-ssh
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew-ssh
chmod +x clear-log
chmod +x change-port
chmod +x restore
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-squid
chmod +x port-websocket
chmod +x wbmn
chmod +x xp
chmod +x xp2
chmod +x kernel-updt
chmod +x user-list
chmod +x user-lock
chmod +x user-unlock
chmod +x user-password
chmod +x antitorrent
chmod +x cfa
chmod +x cfd
chmod +x cfp
chmod +x swap
chmod +x check-sc
chmod +x ssh2
chmod +x autoreboot
chmod +x bbr
chmod +x port-ohp
chmod +x port-xray
chmod +x panel-domain
chmod +x system
chmod +x themes
chmod +x update
chmod +x run-update
chmod +x message-ssh
chmod +x dns
chmod +x nf
chmod +x netf
chmod +x ins-helium
echo "0 1 * * * root delete" >> /etc/crontab
echo "0 2 * * * root xp" >> /etc/crontab
echo "0 5 * * * root reboot" >> /etc/crontab
echo "0 6 * * * root backup" >> /etc/crontab
echo "0 8 * * * root clear-log" >> /etc/crontab
echo "0 23 * * * root backup" >> /etc/crontab
echo "0 3 * * * root /usr/bin/xp" >> /etc/crontab
echo "0 4 * * * root /usr/bin/delete" >> /etc/crontab
echo "0 9 * * * root /usr/bin/clear-log" >> /etc/crontab
#echo "10 23 * * * root /usr/bin/backup" >> /etc/crontab

# // remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y

# // finishing
cd
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
