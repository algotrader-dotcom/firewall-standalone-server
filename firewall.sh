#!/bin/sh
# eth0 is public , eth1 is LAN with network 192.168.175.0/24
# Flushing all rules
whitelist_ip="your_ip"

iptables -F
iptables -X

# Setting default filter policy
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Allow access internet for LAN
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state  --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# OpenVPN
#iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

# Allow SSH from limited
iptables -I INPUT -p tcp --dport 22 -s $whitelist_ip,192.168.175.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT
