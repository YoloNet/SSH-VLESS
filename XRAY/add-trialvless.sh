#!/bin/bash

# Function to generate a random string
generate_random_string() {
    echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)
}

# Function to send message to Telegram
send_telegram_message() {
    local message="$1"
    local token=$(cat /root/yoloautosc/tele_token.txt)
    local chat_id=$(cat /root/yoloautosc/tele_id.txt)
    local url="https://api.telegram.org/bot$token/sendMessage"
    message=$(echo -n "$message" | jq -sRr @uri)
    curl -s -X POST "$url" -d "chat_id=$chat_id" -d "text=$message" -d "parse_mode=Markdown"
}

# Set variables
domain=$(cat /root/yoloautosc/domain)
fastly_domain=$(cat /root/yoloautosc/fastly_domain)
tls="$(cat ~/log-install.txt | grep -w "VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VLESS WS None TLS" | cut -d: -f2|sed 's/ //g')"

# Generate username with random string
user="trial$(generate_random_string)"

# Set expiry date to 1 day from now
exp=$(date -d "+1 day" +"%Y-%m-%d")
hariini=$(date -d "0 days" +"%Y-%m-%d")

# Generate UUID
uuid=$(cat /proc/sys/kernel/random/uuid)

# Add user to XRAY config
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/vless.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /usr/local/etc/xray/none.json

# Restart XRAY service
systemctl restart xray
systemctl restart xray@config
systemctl restart xray@vless
systemctl restart xray@none
service cron restart

# Generate config links
vlesstls="vless://${uuid}@${domain}:${tls}?type=ws&encryption=none&security=tls&host=${domain}&path=/ws&allowInsecure=1&sni=${domain}#XRAY_VLESS_TLS_${user}"
vlessnontls="vless://${uuid}@${domain}:${none}?type=ws&encryption=none&security=none&host=${domain}&path=/ws#XRAY_VLESS_NON_TLS_${user}"

digi_apn="vless://${uuid}@mobile.useinsider.com:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=${domain}#${user}(Digi Apn)"
digi_booster="vless://${uuid}@162.159.133.61:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=${domain}#${user}(Digi Booster)"
celcom_booster="vless://${uuid}@104.17.148.22:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=www.speedtest.net.${domain}#${user}(Celcom 0Basic/Booster)"
maxis_sabah="vless://${uuid}@ookla.com:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=${fastly_domain}#${user}(Maxsit Bypass Sabah)"
maxis_freeze="vless://${uuid}@ookla.com:443?security=tls&encryption=none&type=ws&headerType=none&path=/ws&sni=ookla.com&host=${fastly_domain}#${user}(Maxis Freeze)"
umobile_funz="vless://${uuid}@${domain}:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=m.pubgmobile.com#${user}(UMOBILE FUNZ)"
yes_exp_live="vless://${uuid}@104.17.113.188:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=tap-database.who.int.${domain}#${user}(Yes Exp/Live)"
unifi_bypass="vless://${uuid}@opensignal.com.${domain}:80?security=none&encryption=none&type=ws&headerType=none&path=/ws&host=opensignal.com.${domain}#${user}(Unifi NoSub)"

# Prepare Telegram message
telegram_message="
==================================
👤 USER : ${user}
⏳ EXPIRE : ${exp}
==================================
Config 1 (VLESS TLS):
\`\`\`
${vlesstls}
\`\`\`
==================================
Config 2 (VLESS Non-TLS): 
\`\`\`
${vlessnontls}
\`\`\`
==================================
Config 3 (Digi APN): 
\`\`\`
${digi_apn}
\`\`\`
==================================
Config 4 (Digi Booster): 
\`\`\`
${digi_booster}
\`\`\`
==================================
Config 5 (Celcom Booster): 
\`\`\`
${celcom_booster}
\`\`\`
==================================
Config 6 (Maxis Sabah): 
\`\`\`
${maxis_sabah}
\`\`\`
==================================
Config 7 (Maxis Freeze): 
\`\`\`
${maxis_freeze}
\`\`\`
==================================
Config 8 (Umobile Funz): 
\`\`\`
${umobile_funz}
\`\`\`
==================================
Config 9 (Yes Exp/Live): 
\`\`\`
${yes_exp_live}
\`\`\`
==================================
Config 10 (Unifi Bypass): 
\`\`\`
${unifi_bypass}
\`\`\`
==================================
💻 Server by : @redvpn121
📢 Channel : @nolimitdata
👥 Group : @redvpngroup
==================================
⚠️ FOLLOW RULES OR BAN !
❌ NO TORRENT
❌ NO SHARING ID/MULTILOGIN
❌ NO HACKING/ILLEGAL USE
❌ NO PS4/XBOX
==================================
✅ Done"

# Send message to Telegram
send_telegram_message "$telegram_message"

echo "Trial account created and message sent to Telegram successfully!"