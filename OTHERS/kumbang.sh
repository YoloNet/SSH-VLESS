#!/bin/bash

clear
bugdigi=/root/.yolonet/.kumbang/digi
bugumo=/root/.yolonet/.kumbang/umobile
bugmaxis=/root/.yolonet/.kumbang/maxis
bugunifi=/root/.yolonet/.kumbang/unifi
bugyodoo=/root/.yolonet/.kumbang/yodoo
bugcelcom=/root/.yolonet/.kumbang/celcom
installed=/root/.yolonet/.kumbang/install
done=$(cat $installed | grep -w "done" | wc -l)
if [[ ${done} == '1' ]]; then
    echo -ne "BUG DIGI : "
    read bug_digi
    echo "$bug_digi" >$bugdigi
    echo -ne "BUG UMOBILE : "
    read bug_digi
    echo "$bug_digi" >$bugumo
    echo -ne "BUG MAXIS : "
    read bug_digi
    echo "$bug_digi" >$bugmaxis
    echo -ne "BUG UNIFI : "
    read bug_digi
    echo "$bug_digi" >$bugunifi
    echo -ne "BUG YODOO : "
    read bug_digi
    echo "$bug_digi" >$bugyodoo
    echo -ne "BUG CELCOM : "
    read bug_digi
    echo "$bug_digi" >$bugcelcom

else
mkdir /root/.yolonet
mkdir /root/.yolonet/.kumbang
echo 'bug.com' >$bugdigi
echo 'bug.com' >$bugumo
echo 'bug.com' >$bugmaxis
echo 'bug.com' >$bugunifi
echo 'bug.com' >$bugyodoo
echo 'bug.com' >$bugcelcom
echo 'done' >$installed
clear
kumbang
fi

read -n 1 -s -r -p "Press any key to back on menu"
menu
