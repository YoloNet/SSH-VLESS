#!/bin/bash
# / / AutoCheck by yolonet

# / / check online users vmess
check_online_users_vmess() {
    echo -n > /tmp/ipvmess.txt
    echo -n > /root/vmessonline.txt
    data=( `cat /usr/local/etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);

    for akun in "${data[@]}"; do
        if [[ -z "$akun" ]]; then
            akun="tidakada"
        fi
        data2=( $(cat /var/log/xray/access.log | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | sort -u) )
        ipvmess=()

        for ip in "${data2[@]}"; do
            jum=$(cat /var/log/xray/access.log | grep -Fw "$akun" | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | grep -Fw "$ip" | sort -u)
            if [[ "$jum" = "$ip" ]]; then
                ipvmess+=("$jum")
            else
                echo "$ip" >> /tmp/ipvmess.txt
            fi
        done
    done

    sort /tmp/ipvmess.txt | uniq > /tmp/totalonlinevmess.txt 2>/dev/null
    totaluseronlinevmess=$(cat /tmp/totalonlinevmess.txt | wc -l)

    echo $totaluseronlinevmess > /root/vmessonline.txt # // save the total online user

rm -rf /tmp/ipvmess.txt>/dev/null 2>&1
rm -rf /tmp/totalonlinevmess.txt>/dev/null 2>&1
}
# // cek online user vless
check_online_users_vless() {
    echo -n > /tmp/ipvless.txt
    echo -n > /root/vlessonline.txt # save the total vless user online to the file
    data=( `cat /usr/local/etc/xray/vless.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);

    for akun in "${data[@]}"; do
        if [[ -z "$akun" ]]; then
            akun="tidakada"
        fi
        
        data2=( $(cat /var/log/xray/access2.log | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | sort -u) )
        ipvless=()

        for ip in "${data2[@]}"; do
            jum=$(cat /var/log/xray/access2.log | grep -Fw "$akun" | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | grep -Fw "$ip" | sort -u)
            if [[ "$jum" = "$ip" ]]; then
                ipvless+=("$jum")
            else
                echo "$ip" >> /tmp/ipvless.txt
            fi
        done
    done

    sort /tmp/ipvless.txt | uniq > /tmp/totalonlinevless.txt 2>/dev/null
    totaluseronlinevless=$(cat /tmp/totalonlinevless.txt | wc -l)

    echo $totaluseronlinevless > /root/vlessonline.txt # // save the total online user

rm -rf /tmp/ipvless.txt>/dev/null 2>&1
rm -rf /tmp/totalonlinevless.txt>/dev/null 2>&1
}

# / /Cek Online TROJAN TCP XTLS 
check_online_users_xtrojan() {
    echo -n > /tmp/ipxtrojan.txt >/dev/null 2>&1
    echo -n > /root/trojanxtlsonline.txt # save the total vless user online to the file
    data=( $(cat /usr/local/etc/xray/xtrojan.json | grep '^###' | awk '{print $2}' | sort -u) )
        
    for akun in "${data[@]}"; do
        if [[ -z "$akun" ]]; then
            akun="tidakada"
        fi
        
        data2=( $(cat /var/log/xray/access5.log | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | sort -u) )
        ipxtrojan=()

        for ip in "${data2[@]}"; do
            jum=$(cat /var/log/xray/access5.log | grep -w "$akun" | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort -u)
            if [[ "$jum" = "$ip" ]]; then
                ipxtrojan+=("$jum")
            else
                echo "$ip" >> /tmp/ipxtrojan.txt 2>/dev/null
            fi
        done
    done

    sort /tmp/ipxtrojan.txt | uniq > /tmp/totalonlinextrojan.txt>/dev/null 2>&1
    totaluseronlinextrojan=$(cat /tmp/totalonlinextrojan.txt | wc -l)

    echo $totaluseronlinextrojan > /root/trojanxtlsonline.txt # // save the total online user

rm -rf /tmp/ipxtrojan.txt >/dev/null 2>&1
rm -rf /tmp/totalonlinextrojan.txt >/dev/null 2>&1
}

# / /Cek Online TROJAN WEBSOCKET
check_online_users_trojanws() {
    echo -n > /tmp/iptrojanws.txt >/dev/null 2>&1
    echo -n > /root/trojanwsonline.txt # save the total vless user online to the file
    data=( $(cat /usr/local/etc/xray/trojanws.json | grep '^###' | awk '{print $2}' | sort -u) )
        
    for akun in "${data[@]}"; do
        if [[ -z "$akun" ]]; then
            akun="tidakada"
        fi
        echo -n > /tmp/iptrojanws.txt >/dev/null 2>&1
        data2=( $(cat /var/log/xray/access3.log | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | sort -u) )
        iptrojanws=()

        for ip in "${data2[@]}"; do
            jum=$(cat /var/log/xray/access3.log | grep -w "$akun" | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort -u)
            if [[ "$jum" = "$ip" ]]; then
                iptrojanws+=("$jum")
            else
                echo "$ip" >> /tmp/iptrojanws.txt 2>/dev/null
            fi
        done
    done

    sort /tmp/iptrojanws.txt | uniq > /tmp/totalonlinetrojanws.txt>/dev/null 2>&1
    totaluseronlinextrojan=$(cat /tmp/totalonlinetrojanws.txt | wc -l)

    echo $totaluseronlinextrojan > /root/trojanwsonline.txt # // save the total online user

rm -rf /tmp/iptrojanws.txt>/dev/null 2>&1
rm -rf /tmp/totalonlinextrojan.txt>/dev/null 2>&1
}
# // Cek online users TROJAN TCP
check_online_users_trojan() {
    echo -n > /tmp/iptrojan.txt >/dev/null 2>&1
    echo -n > /root/trojanonline.txt # save the total vless user online to the file
    data=( $(cat /usr/local/etc/xray/trojan.json | grep '^###' | awk '{print $2}' | sort -u) )
        
    for akun in "${data[@]}"; do
        if [[ -z "$akun" ]]; then
            akun="tidakada"
        fi
        
        data2=( $(cat /var/log/xray/access4.log | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | sort -u) )
        iptrojanws=()

        for ip in "${data2[@]}"; do
            jum=$(cat /var/log/xray/access4.log | grep -w "$akun" | tail -n 500 | awk '{print $3}' | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort -u)
            if [[ "$jum" = "$ip" ]]; then
                iptrojanws+=("$jum")
            else
                echo "$ip" >> /tmp/iptrojan.txt 2>/dev/null
            fi
        done
    done

    sort /tmp/iptrojan.txt | uniq > /tmp/totalonlinetrojan.txt>/dev/null 2>&1
    totaluseronlinetrojan=$(cat /tmp/totalonlinetrojan.txt | wc -l)

    echo $totaluseronlinetrojan > /root/trojanonline.txt # // save the total online user

rm -rf /tmp/iptrojan.txt>/dev/null 2>&1
rm -rf /tmp/totalonlinextrojan.txt>/dev/null 2>&1
}

# / / / / /  / / END OF CHECK ONLINE USER

# Function to check bandwidth usage using vnstat
# Total BANDWIDTH

ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "$(date +"%b '%y")" | awk '{print $9" "substr ($10, 1, 1)}')"

echo $ttoday > /root/datausedaily.txt
echo $tmon > /root/datausedmonthly.txt

# Function to check RAM and CPU usage
check_usage() {
    # Get CPU usage percentage
    cpu_usage=$(top -bn1 | awk '/%Cpu/{print $2}' | cut -d. -f1)

    # Get memory usage percentage
    mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    echo $cpu_usage% > cpuusage.txt
    echo $mem_usage% > memusage.txt
    
    }

# // execute ALL the function
check_online_users_vmess
check_online_users_vless
check_online_users_xtrojan
check_online_users_trojanws
check_online_users_trojan
check_usage