#!/usr/bin/env bash


function install_basic_packages() {
    apt-get update

    apt-get install -y dos2unix
    apt-get install -y git
    apt-get install -y git-review
    apt-get install -y ipython
    apt-get install -y python
    apt-get install -y samba
    apt-get install -y tree
    apt-get install -y vim
}


function docker_install() {
    docker version > /dev/null
    if [ $? = 0 ]; then
        return
    fi

    wget -qO- https://get.docker.com/ | sh
    rm -f /etc/apt/sources.list.d/docker.list
}


function mount_data_disk() {
    mount | grep xvde > /dev/null
    if [ $? = 0 ]; then
        return
    fi

    mount -t ext4 /dev/xvde /opt > /dev/null
    if [ $? = 0 ]; then
        return
    fi

    echo "Cannot mount /dev/xvde"
    mkfs -t ext4 /dev/xvde
    mount -t ext4 /dev/xvde /opt > /dev/null

    cat /etc/fstab | grep -e 'xvde' > /dev/null
    if [ $? != 0 ]; then
        echo "make ext4 fs for /dev/xvde"
        cat << EOF >> /etc/fstab
/dev/xvde /opt ext4 defaults 0 1
EOF
    fi
}

function samba_config_and_restart() {
    cat /etc/samba/smb.conf | grep -e 'share my project' > /dev/null
    if [ $? = 0 ]; then
        echo "samba already configured"
        return
    fi

    cat << EOF >> /etc/samba/smb.conf
security = share
[share]
   comment = share my project
   path = /opt
   read only = no
   guest ok = yes
   browseable = yes
EOF

     service smbd restart
}

function main () {
    mount_data_disk
    install_basic_packages
    docker_install
    samba_config_and_restart
}


main
