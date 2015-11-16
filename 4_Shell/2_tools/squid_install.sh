#!/usr/bin/env bash


function squid3_package_install() {
    apt-get update
    apt-get install -y squid3
}

function squid3_config() {
    if [[ ! -f /etc/squid3/squid.conf_bkp ]]; then
        mv /etc/squid3/squid.conf /etc/squid3/squid.conf_bkp
    fi

    cat > /etc/squid3/squid.conf << EOF
acl all src 0.0.0.0/0.0.0.0
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT
acl wan dst 0.0.0.0/0.0.0.0

http_access wan

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access allow all
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .               0       20%     4320
EOF
}

function squid3_service_start() {
    service squid3 restart
    ps aux | grep squid3 | grep -v grep > /dev/null
    if [ $? != 0 ]; then
        /usr/sbin/squid3 -N -YC -f /etc/squid3/squid.conf > /dev/null 2>&1 &
    fi
}

function main() {
    squid3_package_install
    squid3_config
    squid3_service_start
}

main
