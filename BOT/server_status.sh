#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : vless only + websocket + tls + vision
# SC Remod by YOLONET
# TELE BOT TOOLS BY YOLONET
# =========================================

## Foreground
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
NC='\e[0m'

IPVPS=$(curl -s https://checkip.amazonaws.com)
date=$(date +"%d-%m-%Y-%H:%M:%S")
domain=$(cat /root/yoloautosc/domain)

# TOTAL ACC XRAYS WS & XTLS
tvmess=$(grep -c -E "^### $user" "/usr/local/etc/xray/config.json")
tvless=$(grep -c -E "^### $user" "/usr/local/etc/xray/vless.json")
ttrws=$(grep -c -E "^### $user" "/usr/local/etc/xray/trojanws.json")
ttr=$(grep -c -E "^### $user" "/usr/local/etc/xray/trojan.json")

Total_User=$(($tvmess + $tvless + $ttrws + $ttr))

#Total Online user




# RAM & CPU Info
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )

# Get CPU usage percentage
cpu_usage=$(top -bn1 | awk '/%Cpu/{print $2}' | cut -d. -f1)

# Get memory usage percentage
mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

# Replace the following values with your own Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN=$(cat /root/yoloautosc/tele_token.txt)
TELEGRAM_CHAT_ID=$(cat /root/yoloautosc/tele_id.txt)

send_telegram_message() {
    message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID&text=$message"
}

# Send notification to Telegram
send_server_status() {
send_telegram_message "Server status for: $IPVPS
    DOMAIN      : $domain
    DATE        : $date
    CPU USAGE   : $cpu_usage%
    RAM USAGE   : $mem_usage%
    TOTAL USER  : $Total_User" &> /dev/null
}
send_server_status