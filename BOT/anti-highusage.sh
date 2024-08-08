#!/bin/bash

# Telegram Bot Token and Chat ID
TELEGRAM_BOT_TOKEN=$(cat /root/yoloautosc/tele_token.txt)
TELEGRAM_CHAT_ID=$(cat /root/yoloautosc/tele_id.txt)

# Function to send message to Telegram
send_telegram_message() {
    message="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID&text=$message"
}

# Function to get server IP
get_server_ip() {
    hostname=$(hostname)
    server_ip=$(hostname -I | awk '{print $1}')
    echo "$server_ip"
}

# Function to check CPU and memory usage
check_usage() {
    # Get CPU usage percentage
    cpu_usage=$(top -bn1 | awk '/%Cpu/{print $2}' | cut -d. -f1)

    # Get memory usage percentage
    mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    echo "CPU Usage: $cpu_usage%"
    echo "Memory Usage: $mem_usage%"

    # Check if CPU or memory usage is above 80%
    if [ "$cpu_usage" -gt 70 ] || [ "$(echo "$mem_usage > 70" | bc)" -eq 1 ]; then
        echo "CPU or Memory usage is above 80%."

        # Get server IP
        server_ip=$(get_server_ip)
        
        # Send notification to Telegram with server IP
        send_telegram_message "Server $server_ip is rebooting! Usage is over 80%!"
        
        # Reboot the server
        echo "Rebooting the server..."
        reboot
    else
        echo "CPU and Memory usage are within limits."
    fi
}

# Execute the function
check_usage
