#!/bin/bash
#Autoscript-Lite By YoLoNET
P='\e[0;35m'
B='\033[0;36m'
N='\e[0m'
clear
echo -e "\e[36m╒════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;41;46m                SYSTEM MENU                 \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════╛\033[0m

 [\033[1;36m•1 \033[0m]  Update Script
 [\033[1;36m•2 \033[0m]  COMING SOON
 [\033[1;36m•3 \033[0m]  COMING SOON
 [\033[1;36m•4 \033[0m]  COMING SOON
 [\033[1;36m•5 \033[0m]  COMING SOON
 [\033[1;36m•6 \033[0m]  Back To Main Menu"
echo ""
echo -e " \033[1;37mPress [ Ctrl+C ] • To-Exit-Script\033[0m"
echo ""
echo -ne "Select menu : "; read x
if [[ $(cat /opt/.ver) = $serverV ]] > /dev/null 2>&1; then
    if [[ $x -eq 1 ]]; then
       updater_sc
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 2 ]]; then
       system-menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 3 ]]; then
       system-menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 4 ]]; then
       system-menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 5 ]]; then
       system-menu
       read -n1 -r -p "Press any key to continue..."
       menu
    elif [[ $x -eq 6 ]]; then
       clear
       menu
    else
       clear
       system-menu
    fi
fi
