#!/bin/bash
#Autoscript-Lite By YoLoNET

#----- Auto Remove Vless
data=( `cat /usr/local/etc/xray/vless.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/vless.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/vless.json
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/none.json
rm -f /home/vps/public_html/$user-VLESSTLS.yaml /home/vps/public_html/$user-VLESSNTLS.yaml
systemctl restart xray@vless.service
systemctl restart xray@vnone.service
fi
done

#----- Auto Remove Vless TCP XTLS
data=( `cat /usr/local/etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/config.json
rm -f /home/vps/public_html/$user-VLESSDIRECT.yaml /home/vps/public_html/$user-VLESSSPLICE.yaml
systemctl restart xray@xtls.service
fi
done