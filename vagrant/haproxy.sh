#!/bin/bash
#THIS SCRIPT IS TO INSTALL AND CONFIGURE HAPROXY
 
# BEGIN SETUP FOR HAPROXY
echo "-- --------------------------"
echo "-- BEGIN SETUP FOR HAPROXY --"
echo "-----------------------------"

# SETUP FOR HAPROXY 
echo "-- Updating packages --"
apt-get update -y -qq
 
echo "-- Installing HAProxy --"
apt-get install -y haproxy > /dev/null 2>&1
 
echo "-- Enabling HAProxy as a start-up deamon --"
cat > /etc/default/haproxy <<EOF
ENABLED=1
EOF
 
echo "-- Configuring HAProxy --"
cat > /etc/haproxy/haproxy.cfg <<EOF
global
    log /dev/log local0
    log localhost local1 notice
    user haproxy
    group haproxy
    maxconn 2000
    daemon
 
defaults
    log global
    mode http
    option httplog
    option dontlognull
    retries 3
    timeout connect 5000
    timeout client 50000
    timeout server 50000
 
frontend haproxy
    bind *:80
    default_backend webservers
 
backend webservers
    balance roundrobin
    stats enable
    stats auth admin:admin
    stats uri /haproxy?stats
    option httpchk
    option forwardfor
    option http-server-close
    server webserver1 192.168.56.115:80 check
    server webserver2 192.168.56.116:80 check
EOF
 
echo "-- Validating HAProxy configuration --"
haproxy -f /etc/haproxy/haproxy.cfg -c
 
echo "-- Starting HAProxy --"
service haproxy start
 
# END OF THE SETUP
echo "------------------------------"
echo "-- END OF SETUP FOR HAPROXY --"
echo "------------------------------"
