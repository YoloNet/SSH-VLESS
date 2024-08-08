 <h2 align="center">AutoScript XRAY VLESS ONLY VPN By YoLoNet <img src="https://img.shields.io/badge/Version-1.0-blue.svg"></h2>


<h2 align="center"> Supported Linux Distribution</h2>
<h2 align="center"> RECCOMENDED DEBIAN 10</h2>
<p align="center"><img src="https://d33wubrfki0l68.cloudfront.net/5911c43be3b1da526ed609e9c55783d9d0f6b066/9858b/assets/img/debian-ubuntu-hover.png"></p>
<p align="center"><img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2010&message=Buster&color=blue"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2011&message=Bullseye&color=blue"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2018&message=18.04 LTS&color=blue"> <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2020&message=20.04 LTS&color=blue"></p>

<p align="center"><img src="https://img.shields.io/badge/Service-OpenSSH-success.svg"> <img src="https://img.shields.io/badge/Service-Dropbear-success.svg">  <img src="https://img.shields.io/badge/Service-Websocket-success.svg"> <img src="https://img.shields.io/badge/Service-BadVPN-success.svg">  <img src="https://img.shields.io/badge/Service-Stunnel-success.svg">  <img src="https://img.shields.io/badge/Service-OpenVPN-success.svg">  <img src="https://img.shields.io/badge/Service-Squid3-success.svg">  <img   src="https://img.shields.io/badge/Service-Webmin-success.svg">  <img src="https://img.shields.io/badge/Service-OHP-success.svg">  <img
src="https://img.shields.io/badge/Service-Xray-success.svg">  <img src= "https://img.shields.io/badge/Service-SSR-success.svg">  <img src="https://img.shields.io/badge/Service-Trojan Go-success.svg"> <img src="https://img.shields.io/badge/Service-Trojan-success.svg"> <img src="https://img.shields.io/badge/Service-WireGuard-success.svg"> <img src="https://img.shields.io/badge/Service-Shadowsocks-success.svg">

## Commands : <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=powershell&label=Shell&message=Bash%20Script&color=lightgray">

## Update & Upgrade First Your VPS for Debian 10 & 11

  ```html
  apt-get update && apt-get upgrade -y && update-grub && sleep 2 && reboot

  ```

## Update & Upgrade First Your VPS for Ubuntu 18.04 & 20.04

  ```html
  apt-get update && apt-get upgrade -y && apt dist-upgrade -y && update-grub && sleep 2 && reboot

  ```
 
## INSTALLATION SCRIPT // USE ONLY DEBIAN 10 FOR STABILITY

  ```html
  sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/YoloNet/vless-ws-only/main/setup-lite.sh && chmod +x setup-lite.sh && sed -i -e 's/\r$//' setup-lite.sh && screen -S setup-lite ./setup-lite.sh

  ```
## INSTALLATION LINK IF ASKED

  ```html
  raw.githubusercontent.com/YoloNet/SSH-VLESS/main/

  ```
 

<h2 align="center"><img src="https://img.shields.io/badge/DESCRIPTION-%3A-blueviolet.svg"></h2>

**PORT INFO :**
```
PORT 443 :
- SSH WS TLS
- VMESS TLS
- VLESS TLS
- VLESS TCP XTLS VISION ( use http injector,some client still dont support vision)

PORT 80 :
- SSH WS HTTP
- VMESS NON TLS
- VLESS NON TLS
```
