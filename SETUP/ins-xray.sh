#!/bin/bash
# XRAY Core & Trojan-Go Installation Setup
# By YoLoNET
#------------------------------------------
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

echo -e ""
domain=$(cat /root/yoloautosc/domain)
sleep 1
echo -e "[ ${green}INFO${NC} ] XRAY Core Installation Begin . . . "

apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Kuala_Lumpur
chronyc sourcestats -v
chronyc tracking -v
date
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# Make Folder Log XRAY
mkdir -p /var/log/xray
chmod +x /var/log/xray

# Make Folder XRAY
mkdir -p /usr/local/etc/xray

# Download XRAY Core Latest Link
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# Installation Xray Core
xraycore_link="https://github.com/YoloNet/Xray-core/releases/download/1.8.19/Xray-linux-64.zip"

# Unzip Xray Linux 64
cd `mktemp -d`
curl -sL "$xraycore_link" -o xray.zip
unzip -q xray.zip && rm -rf xray.zip
mv xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

# generate certificates
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain -d sshws.$domain --standalone -k ec-256 --listen-v6
~/.acme.sh/acme.sh --installcert -d $domain -d sshws.$domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
chmod 755 /usr/local/etc/xray/xray.key;
service squid start
systemctl restart nginx
sleep 0.5;
clear;

# Nginx directory file download
mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Installing VLESS XTLS - MAIN FILE FOR FALLBACK
cat> /usr/local/etc/xray/config.json << END
{
   "log":{
      "access":"/var/log/xray/xtls-access.log",
      "error":"/var/log/xray/xtls-error.log",
      "loglevel":"info"
   },
   "inbounds":[
      {
         "port":443,
         "listen":"0.0.0.0",
         "protocol":"vless",
         "settings":{
            "clients":[
               {
                  "id":"${uuid}",
                  "flow":"xtls-rprx-vision",
                  "level":0,
                  "email":""
#xtls
               }
            ],
            "decryption":"none",
            "fallbacks":[
               {
                  "dest": 82,
                  "xver":1
               },
               {
                  "path":"/ws",
                  "dest":1312,
                  "xver":1
               }
            ]
         },
         "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "alpn": [
                        "h2",
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/usr/local/etc/xray/xray.crt",
                            "keyFile": "/usr/local/etc/xray/xray.key"
                        }
                    ]
                },
                "sniffing": {
                  "enabled": true,
                  "destOverride": [
                    "http",
                    "tls"
                  ]
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
END
# // INSTALLING VLESS NON-TLS
cat> /usr/local/etc/xray/none.json << END
{
  "log": {
    "access": "/var/log/xray/vless_ntls.log",
    "error": "/var/log/xray/vless_ntls_error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
     "listen": "0.0.0.0",
     "port": "80",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "level": 0,
            "email": ""
#none
         }
        ],
        "decryption": "none"
      },
      "encryption": "none",
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/ws"
        }
      }
    }
  ],
"outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

# // INSTALLING VLESS TLS
cat > /usr/local/etc/xray/vless.json << END
{
  "log": {
    "access": "/var/log/xray/vless_tls.log",
    "error": "/var/log/xray/vless_error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1312,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "level": 0,
            "email": ""
#tls
}
        ],
        "decryption": "none"
      },
	  "encryption": "none",
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings":
            {
              "acceptProxyProtocol": true,
              "path": "/ws"
            }
      }
    }
  ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}

END

rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service.d
cat> /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://YoLoNET-Project.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

END

cat> /etc/systemd/system/xray@.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://YoLoNET-Project.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/%i.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

END

sleep 1
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}OK${NC} ] Enable & restart xray "

# enable xray vless ws tls
echo -e "[ ${green}OK${NC} ] Restarting Vmess WS"
systemctl daemon-reload
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray.service

# enable xray vless ws ntls
systemctl daemon-reload
systemctl enable xray@none.service
systemctl start xray@none.service
systemctl restart xray@none.service

# enable xray xtls
echo -e "[ ${green}OK${NC} ] Restarting Vless WS"
systemctl daemon-reload
systemctl enable xray@config.service
systemctl start xray@config.service
systemctl restart xray@config.service

# enable xray vless
echo -e "[ ${green}OK${NC} ] Restarting Vless XTLS"
systemctl daemon-reload
systemctl enable xray@vless.service
systemctl start xray@vless.service
systemctl restart xray@vless.service

# enable service multiport
echo -e "[ ${green}OK${NC} ] Restarting Multiport Service"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx

sleep 1

cd /usr/bin

# // VLESS WS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vless WS Files"
sleep 1
wget -O add-vless "https://${Server_URL}/XRAY/add-vless.sh" && chmod +x add-vless
wget -O cek-vless "https://${Server_URL}/XRAY/cek-vless.sh" && chmod +x cek-vless
wget -O add-trialvless "https://${Server_URL}/XRAY/add-trialvless.sh" && chmod +x add-trialvless
wget -O del-vless "https://${Server_URL}/XRAY/del-vless.sh" && chmod +x del-vless
wget -O renew-vless "https://${Server_URL}/XRAY/renew-vless.sh" && chmod +x renew-vless
wget -O user-vless "https://${Server_URL}/XRAY/user-vless.sh" && chmod +x user-vless

# // VLESS TCP XTLS
echo -e "[ ${green}INFO${NC} ] Downloading XRAY Vless TCP XTLS Files"
sleep 1
wget -O add-xray "https://${Server_URL}/XRAY/add-xray.sh" && chmod +x add-xray
wget -O cek-xray "https://${Server_URL}/XRAY/cek-xray.sh" && chmod +x cek-xray
wget -O del-xray "https://${Server_URL}/XRAY/del-xray.sh" && chmod +x del-xray
wget -O renew-xray "https://${Server_URL}/XRAY/renew-xray.sh" && chmod +x renew-xray
wget -O user-xray "https://${Server_URL}/XRAY/user-xray.sh" && chmod +x user-xray

# // OTHER FILES
echo -e "[ ${green}INFO${NC} ] Downloading Others Files"
wget -O certxray "https://${Server_URL}/XRAY/cert.sh" && chmod +x certxray

sleep 1

cd /usr/bin
# // MENU FILES
echo -e "[ ${green}INFO${NC} ] Downloading Menu Files"
sleep 1
wget -O menu-vless "https://${Server_URL}/MENU/menu-vless.sh" && chmod +x menu-vless
wget -O menu-xray "https://${Server_URL}/MENU/menu-xray.sh" && chmod +x menu-xray

cd
mv /root/domain /usr/local/etc/xray/
rm -f ins-xray.sh
