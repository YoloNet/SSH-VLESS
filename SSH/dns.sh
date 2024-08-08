#!/bin/bash
#DNS Setup By RedVPN
MYIP=$(curl -sS ipv4.icanhazip.com)
clear

function autoaddipserver_updateDNS_controld(){
clear
[[ ! -f /usr/bin/jq ]] && {
    apt install jq
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --email)
        email="$2"
        shift # past argument
        shift # past value
        ;;
    --password)
        pass="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$email" ] || [ -z "$pass" ]; then
    read -p "Email : " email
    read -p "Pass  : " pass
fi

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Add IP
addIP=$(curl -Ss --request POST \
    --url "https://api.controld.com/access?device_id=${deviceId}" \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' \
    --data "{\"ips\":[\"$(curl -Ss ipv4.icanhazip.com)\"]}" | grep -ic "1 IPs added")

# Get the legacy IPv4 resolver
legacyIpv4=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].legacy_ipv4.resolver')

#adding DNS to server resolver
sudo dd if=/dev/null of=/etc/resolvconf/resolv.conf.d/head
echo "nameserver $legacyIpv4" | sudo tee /etc/resolvconf/resolv.conf.d/head
clear -x
sudo systemctl restart resolvconf.service > /dev/null 
clear -x
sudo resolvconf --enable-updates > /dev/null 
clear -x
sudo resolvconf -u > /dev/null 
clear -x
cat /etc/resolv.conf
echo "Done Adding Controld DNS to resolver"
sleep 1
clear

# Print result
if [[ ${addIP} != '0' ]]; then
    echo "Success, Add $(curl -Ss ipv4.icanhazip.com)"
    echo "Credit : @sam_sfx"
else
    echo "Sorry, Unsuccessful"
    echo "Credit : @sam_sfx"
fi
}

function changeDNS_manual() {
clear -x
sudo systemctl enable resolvconf.service > /dev/null && clear -x && sudo systemctl start resolvconf.service > /dev/null
clear -x
echo " "
read -p "KEY IN IP DNS: " ip2
sudo dd if=/dev/null of=/etc/resolvconf/resolv.conf.d/head
echo "nameserver $ip2" | sudo tee /etc/resolvconf/resolv.conf.d/head
clear -x
sudo systemctl restart resolvconf.service > /dev/null 
clear -x
sudo resolvconf --enable-updates > /dev/null 
clear -x
sudo resolvconf -u > /dev/null 
clear -x
cat /etc/resolv.conf
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

function add_default_custom_rules_kontold(){
[[ ! -f /usr/bin/jq ]] && {
    apt install jq
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --email)
        email="$2"
        shift # past argument
        shift # past value
        ;;
    --password)
        pass="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$email" ] || [ -z "$pass" ]; then
    read -p "Email : " email
    read -p "Pass  : " pass
fi

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Get the first Profile ID
profileId=$(curl -sS --request GET \
     --url https://api.controld.com/profiles \
     --header 'accept: application/json' \
     --header "authorization: ${sessionID}" \
     | jq -r '.body.profiles[0].PK')

#set proxy location. refer to https://docs.controld.com/reference/get_proxies to for other location.
#Default location is MALAYSIA
echo -e "Select Country To Redirect :"
echo -e "1] Malaysia"
echo -e "2] Indonesia"
echo -e "3] United States"
# Function to print the country names based on the user's input
print_country_name() {
  case $1 in
    1)
      echo "KUL"
      ;;
    2)
      echo "CGK"
      ;;
    3)
      echo "US"
      ;;
    *)
      echo "Invalid input, please enter a number between 1 and 3."
      ;;
  esac
}

# Ask the user to enter a number between 1 and 4
read -p "Enter a number between 1 and 4: " user_input

# Keep asking the user to enter a valid input until they do
while [[ $user_input -lt 1 || $user_input -gt 4 ]]; do
  echo "Invalid input, please enter a number between 1 and 4."
  read -p "Enter a number between 1 and 4: " user_input
done

country_name=$(print_country_name $user_input)
echo $country_name > /root/kontold/country.txt
proxylocation=$(cat /root/kontold/country.txt)

# saving domainlist from github to .txt

list=$(curl -sS https://raw.githubusercontent.com/YoloNet/custom-rules/main/list)
printf '%s\n' "$list" > /root/domains.txt
#######
# Define session ID and file name
fileName="/root/domains.txt"

# Define function to get existing domains
existing_domains() {
    existing_domains=()
    result=$(curl -s -X GET -H "accept: application/json" -H "authorization: ${sessionID}" https://api.controld.com/profiles/${profileId}/rules)
    if [[ ${result} == *"PK"* ]]; then
        while read -r line; do
            domain=$(echo "$line" | sed 's/\./\\\./g')
            if [[ ${result} =~ \"PK\":\ \"$domain\" ]]; then
                echo "Domain $line already exists, skipping..."
            else
                existing_domains+=("$line")
            fi
        done < "$fileName"
    else
        existing_domains=($(cat "$fileName"))
    fi
}

# Call existing_domains function
existing_domains

# Send requests for new domains
for domain in "${existing_domains[@]}"; do
    result=$(curl -s -X POST -H "accept: application/json" -H "authorization: ${sessionID}" -H "content-type: application/x-www-form-urlencoded" --data "status=1&do=3&via=$proxylocation&hostnames[]=$domain" "https://api.controld.com/profiles/${profileId}/rules")
    if [[ ${result} == *"success"* ]]; then
        echo "Domain $domain added successfully!"
    else
        echo "Failed to add domain $domain"
    fi
done
}

#this function add manual custom rules. Onl;y 1 domain at one time
function add_custom_rules_manual(){
clear
[[ ! -f /usr/bin/jq ]] && {
    apt install jq
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --email)
        email="$2"
        shift # past argument
        shift # past value
        ;;
    --password)
        pass="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$email" ] || [ -z "$pass" ]; then
    read -p "Email : " email
    read -p "Pass  : " pass
fi

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Get the first Profile ID
profileId=$(curl -sS --request GET \
     --url https://api.controld.com/profiles \
     --header 'accept: application/json' \
     --header "authorization: ${sessionID}" \
     | jq -r '.body.profiles[0].PK')

#set proxy location. refer to https://docs.controld.com/reference/get_proxies to for other location.
#Default location is MALAYSIA

echo -e "Select Country To Redirect :"
echo -e "1] Malaysia"
echo -e "2] Indonesia"
echo -e "3] United States"
# Function to print the country names based on the user's input
print_country_name() {
  case $1 in
    1)
      echo "KUL"
      ;;
    2)
      echo "CGK"
      ;;
    3)
      echo "US"
      ;;
    *)
      echo "Invalid input, please enter a number between 1 and 3."
      ;;
  esac
}

# Ask the user to enter a number between 1 and 4
read -p "Enter a number between 1 and 4: " user_input

# Keep asking the user to enter a valid input until they do
while [[ $user_input -lt 1 || $user_input -gt 4 ]]; do
  echo "Invalid input, please enter a number between 1 and 4."
  read -p "Enter a number between 1 and 4: " user_input
done

country_name=$(print_country_name $user_input)
echo $country_name > /root/kontold/country.txt
proxylocation=$(cat /root/kontold/country.txt)
echo -e "Only 1 domain is allowed in one request"
echo -e ""
read -rp "Enter Your Domain :" -e url

printf '%s\n' "$url" > /root/domains.txt
#######
# Define session ID and file name
fileName="/root/domains.txt"

# Define function to get existing domains
existing_domains() {
    existing_domains=()
    result=$(curl -s -X GET -H "accept: application/json" -H "authorization: ${sessionID}" https://api.controld.com/profiles/${profileId}/rules)
    if [[ ${result} == *"PK"* ]]; then
        while read -r line; do
            domain=$(echo "$line" | sed 's/\./\\\./g')
            if [[ ${result} =~ \"PK\":\ \"$domain\" ]]; then
                echo "Domain $line already exists, skipping..."
            else
                existing_domains+=("$line")
            fi
        done < "$fileName"
    else
        existing_domains=($(cat "$fileName"))
    fi
}

# Call existing_domains function
existing_domains

# Send requests for new domains
for domain in "${existing_domains[@]}"; do
    result=$(curl -s -X POST -H "accept: application/json" -H "authorization: ${sessionID}" -H "content-type: application/x-www-form-urlencoded" --data "status=1&do=3&via=$proxylocation&hostnames[]=$domain" "https://api.controld.com/profiles/${profileId}/rules")
    if [[ ${result} == *"success"* ]]; then
        echo "Domain $domain added successfully!"
    else
        echo "Failed to add domain $domain"
    fi
done
}

#this function bulk add custom rules by url.
function bulk_add_custom_rules(){

[[ ! -f /usr/bin/jq ]] && {
    apt install jq
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --email)
        email="$2"
        shift # past argument
        shift # past value
        ;;
    --password)
        pass="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$email" ] || [ -z "$pass" ]; then
    read -p "Email : " email
    read -p "Pass  : " pass
fi

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Get the first Profile ID
profileId=$(curl -sS --request GET \
     --url https://api.controld.com/profiles \
     --header 'accept: application/json' \
     --header "authorization: ${sessionID}" \
     | jq -r '.body.profiles[0].PK')

#set proxy location. refer to https://docs.controld.com/reference/get_proxies to for other location.
#Default location is MALAYSIA
echo -e "Select Country To Redirect :"
echo -e "1] Malaysia"
echo -e "2] Indonesia"
echo -e "3] United States"
# Function to print the country names based on the user's input
print_country_name() {
  case $1 in
    1)
      echo "KUL"
      ;;
    2)
      echo "CGK"
      ;;
    3)
      echo "US"
      ;;
    *)
      echo "Invalid input, please enter a number between 1 and 3."
      ;;
  esac
}

# Ask the user to enter a number between 1 and 4
read -p "Enter a number between 1 and 4: " user_input

# Keep asking the user to enter a valid input until they do
while [[ $user_input -lt 1 || $user_input -gt 4 ]]; do
  echo "Invalid input, please enter a number between 1 and 4."
  read -p "Enter a number between 1 and 4: " user_input
done

country_name=$(print_country_name $user_input)
echo $country_name > /root/kontold/country.txt
proxylocation=$(cat /root/kontold/country.txt)

echo -e "This function will read your bulk domain from url"
echo -e "Please make sure your domain is in correct format ( 1 domain per line)"
echo -e "Reccomended using github raw links"
echo -e ""
read -rp "Enter Your Domain :" -e linkfile
url=$(curl -sS $linkfile)
printf '%s\n' "$url" > /root/domains.txt
#######
# Define session ID and file name
fileName="/root/domains.txt"

# Define function to get existing domains
existing_domains() {
    existing_domains=()
    result=$(curl -s -X GET -H "accept: application/json" -H "authorization: ${sessionID}" https://api.controld.com/profiles/${profileId}/rules)
    if [[ ${result} == *"PK"* ]]; then
        while read -r line; do
            domain=$(echo "$line" | sed 's/\./\\\./g')
            if [[ ${result} =~ \"PK\":\ \"$domain\" ]]; then
                echo "Domain $line already exists, skipping..."
            else
                existing_domains+=("$line")
            fi
        done < "$fileName"
    else
        existing_domains=($(cat "$fileName"))
    fi
}

# Call existing_domains function
existing_domains

# Send requests for new domains
for domain in "${existing_domains[@]}"; do
    result=$(curl -s -X POST -H "accept: application/json" -H "authorization: ${sessionID}" -H "content-type: application/x-www-form-urlencoded" --data "status=1&do=3&via=$proxylocation&hostnames[]=$domain" "https://api.controld.com/profiles/${profileId}/rules")
    if [[ ${result} == *"success"* ]]; then
        echo "Domain $domain added successfully!"
    else
        echo "Failed to add domain $domain"
    fi
done
}

#one click setup services
function one_click_setup_services(){
    clear
[[ ! -f /usr/bin/jq ]] && {
    apt install jq
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --email)
        email="$2"
        shift # past argument
        shift # past value
        ;;
    --password)
        pass="$2"
        shift # past argument
        shift # past value
        ;;
    *) # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ -z "$email" ] || [ -z "$pass" ]; then
    read -p "Email : " email
    read -p "Pass  : " pass
fi

# Get the user token
token=$(curl -Ss --request POST \
    --url https://api.controld.com/preauth/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\"}" | jq -r '.body.token')

# Get the session ID
sessionID=$(curl -Ss --request POST \
    --url https://api.controld.com/users/login \
    --header 'content-type: application/json' \
    --data "{\"email\":\"$email\",\"password\":\"$pass\",\"ttl\":\"1m\",\"token\":\"$token\"}" | jq -r '.body.session')

# Get the device ID
deviceId=$(curl -Ss --request GET \
    --url https://api.controld.com/devices \
    --header "authorization: ${sessionID}" \
    --header 'content-type: application/json' | jq -r '.body.devices[0].resolvers.uid')

# Get the first Profile ID
profileId=$(curl -sS --request GET \
     --url https://api.controld.com/profiles \
     --header 'accept: application/json' \
     --header "authorization: ${sessionID}" \
     | jq -r '.body.profiles[0].PK')

# List Native Filters
allNativeFilter=$(curl --request GET \
     --url https://api.controld.com/profiles/$profileId/filters \
     --header 'accept: application/json' \
     --header "authorization: ${sessionID}" \ )

list_filters=("torrents" "cryptominers" "fakenews" "drugs" "typo")
for filter in "${list_filters[@]}"
do
  curl --request PUT \
       --url "https://api.controld.com/profiles/$profileId/filters/filter/$filter" \
       --header 'accept: application/json' \
       --header "authorization: ${sessionID}" \
       --header 'content-type: application/x-www-form-urlencoded' \
       --data "status=1"
done
#echo -e "filter updated."
#echo -e "exiting to menu"
#sleep 1
#clear
}
get_nameservers() {
  if [ -e /etc/resolv.conf ]; then
    grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}'
  else
    echo "No /etc/resolv.conf file found."
  fi
}
mydns=$(get_nameservers)
#Check DNS ISP
check_isp() {
    IP="$mydns"
    ISP=$(whois "$IP" | grep -i 'orgname' | awk '{print $2}')
    
    if [ -n "$ISP" ]; then
        echo "$ISP"
    else
        echo "Unable to determine the ISP for IP $IP."
    fi
}
dnsisp=$(check_isp)

#Menu starts below ##
clear
echo -e "\033[0;34m╒════════════════════════════════════════════╕\033[0m"
echo -e " \E[0;41;36m          CONTROLD DNS TOOLS               \E[0m"
echo -e "\033[0;34m╘════════════════════════════════════════════╛\033[0m"
echo -e "Your Current DNS : $mydns by $dnsisp"
echo -e ""
echo -e ""
echo -e " [\e[36m1 \e[0m] ADD VPS IP TO CONTROL.D BY API 
(CONTROLD DNS WILL BE AUTOMATICALLY APPLIED TO YOUR VPS) \e[0m"
echo -e " [\e[36m2 \e[0m] INPUT DNS PERMANENTLY MANUAL"
echo -e " [\e[36m3 \e[0m] ADD CUSTOM RULES (refresh from github)"
echo -e " [\e[36m4 \e[0m] ADD CUSTOM RULES manual"
echo -e " [\e[36m5 \e[0m] BULK ADD CUSTOM RULES from url"
echo -e " [\e[36m6 \e[0m] ONE CLICK SETUP FILTERS"
echo -e " [\e[36m7 \e[0m] BACK TO MAIN MENU"
echo -e ""
echo  "Press [ Ctrl+C ] • To-Exit-Script"
echo -e ""
echo -e "DNS TOOLS by @redvpn121"
echo -e ""
echo -e ""
read -p  "Select From Options [ 1 - 7 ] :" num
echo -e ""
if [[ "$num" = "1" ]]; then
autoaddipserver_updateDNS_controld
elif [[ "$num" = "2" ]]; then
changeDNS_manual
elif [[ "$num" = "3" ]]; then
add_default_custom_rules_kontold
elif [[ "$num" = "4" ]]; then
add_custom_rules_manual
elif [[ "$num" = "5" ]]; then
bulk_add_custom_rules
elif [[ "$num" = "6" ]]; then
one_click_setup_services
elif [[ "$num" = "7" ]]; then
menu
else
clear
echo -e "\e[1;31mYou Entered The Wrong Number, Please Try Again!\e[0m"
sleep 1
dns
fi
