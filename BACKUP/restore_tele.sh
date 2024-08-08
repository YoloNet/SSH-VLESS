#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : vless only + websocket + tls + vision
# SC Remod by YOLONET
# RESTORE TOOLS BY YOLONET
# =========================================

red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
rm -f backup.zip
clear

# Check if jq is installed, if not, install it
if ! command -v jq &> /dev/null; then
    echo -e "[ ${orange}INFO${NC} ] jq is not installed. Installing jq..."
    apt-get update
    apt-get install -y jq
    clear
fi

echo -e "\e[36m╒════════════════════════════════════════════════════╕\033[0m"
echo -e "                   ${WB}»»» RESTORE TOOLS «««${NC}                 "
echo -e "\e[36m╘════════════════════════════════════════════════════╛\033[0m"
# Read the IP from the user
echo -e "forward fail yang anda nak restore dari bot ke bot telegram"
echo -e ""
while true; do
    read -p "Enter the IP address to restore: " restore_ip
    # Check if the input is a number
    if [[ $restore_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        break  # Exit the loop if the input is a number
    else
        echo "Invalid input. Please enter a valid IP ADDRESS."
    fi
done


# Replace the following values with your own Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN=$(cat /root/yoloautosc/tele_token.txt)
TELEGRAM_CHAT_ID=$(cat /root/yoloautosc/tele_id.txt)

# Use the following URL to get updates from the Telegram chat
TELEGRAM_API_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates"

# Get the latest messages from the Telegram chat
updates=$(curl -s "${TELEGRAM_API_URL}")

# Extract the latest backup message with the specified IP from the updates
backup_message=$(echo "$updates" | jq -r --arg ip "$restore_ip" '.result | map(select(.message.caption | contains($ip))) | sort_by(.message.date) | last')

# Check if a matching backup message was found
if [ -z "$backup_message" ]; then
    echo -e "[ ${red}ERROR${NC} ] No backup message found for IP: $restore_ip"
    exit 1
else
    # Extract file ID and caption from the backup message
  file_id=$(echo "$backup_message" | jq -r '.message.document.file_id')
  caption=$(echo "$backup_message" | jq -r '.message.caption')

# Use the following URL to get file information
FILE_INFO_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getFile?file_id=${file_id}"

# Extract file path from the file information
file_path=$(curl -s "$FILE_INFO_URL" | jq -r '.result.file_path')

# Get the file download URL from the file_path
DOWNLOAD_URL="https://api.telegram.org/file/bot${TELEGRAM_BOT_TOKEN}/${file_path}"

wget -O backup.zip "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
    echo -e "[ ${red}ERROR${NC} ] Failed to download backup file. IP ADDRESS SALAH! Exiting."
    rm -f backup.zip
    exit 1
fi

unzip backup.zip
rm -f backup.zip
sleep 1
echo -e "[ ${green}INFO${NC} ] Start Restore . . . "
#cp -r /root/backup/.acme.sh /root/ &> /dev/null
#cp -r /root/backup/premium-script /var/lib/ &> /dev/null
#cp -r /root/backup/xray /usr/local/etc/ &> /dev/null
cp -r /root/root/backup/*.json /usr/local/etc/xray/
cp -r /root/root/backup/public_html /home/vps/ &> /dev/null
cp -r /root/root/backup/crontab /etc/ &> /dev/null
cp -r /root/root/backup/cron.d /etc/ &> /dev/null
rm -rf /root/root/backup
rm -f backup.zip
echo ""
echo -e "[ ${green}INFO${NC} ] VPS Data Restore Complete !"
echo ""
echo -e "[ ${green}INFO${NC} ] Restart All Service"
systemctl restart nginx
systemctl restart xray.service
systemctl restart xray@config.service
systemctl restart xray@none.service
systemctl restart xray@vless.service
service cron restart
echo ""
read -p "$( echo -e "Press ${orange}[ ${NC}${green}Enter${NC} ${CYAN}]${NC} Back to menu . . .") "
menu
fi
