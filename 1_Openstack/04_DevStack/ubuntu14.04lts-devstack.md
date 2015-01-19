
ping -c 5 archive.ubuntu.com
ping -c 5 ubuntu.srt.cn
ping -c 5 mirrors.sohu.com
ping -c 5 mirror.lupaworld.com

deb http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ trusty-backports main restricted universe multiverse

sudo mv /etc/apt/sources.list /etc/apt/sources.list_bkp
sudo cat > /etc/apt/sources.list111 << EOF
deb http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

sudo apt-get update
sudo apt-get dist-upgrade 

sudo reboot
sudo apt-get install git

mkdir $HOME/.pip
cat >$HOME/.pip/pip.conf <<EOF
[global]
index-url = http://pypi.douban.com/simple/
EOF


sudo su
cd /home
git clone https://github.com/openstack-dev/devstack.git
cd devstack/tools/
./create-stack-user.sh

localrc

# Misc
HOST_IP=192.168.7.128
DATABASE_PASSWORD=password
ADMIN_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=password
RABBIT_PASSWORD=password

#change from github to csdn
#GIT_BASE=https://code.csdn.net

## vnc

#enable_service n-spice
#enable_service n-novnc
#enable_service n-xvnc


# Reclone each time
#RECLONE=yes
RECLONE=no

## For Keystone
KEYSTONE_TOKEN_FORMAT=PKI

## For Swift
#SWIFT_REPLICAS=1
#SWIFT_HASH=011688b44136573e209e

# Enable Logging
LOGFILE=/opt/stack/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=True
SCREEN_LOGDIR=/opt/stack/logs

# Pre-requisite
ENABLED_SERVICES=rabbit,mysql,key

## If you want ZeroMQ instead of RabbitMQ (don't forget to un-declare 'rabbit' from the pre-requesite)
#ENABLED_SERVICES+=,-rabbit,-qpid,zeromq

## If you want Qpid instead of RabbitMQ (don't forget to un-declare 'rabbit' from the pre-requesite)
#ENABLED_SERVICES+=,-rabbit,-zeromq,qpid

# Horizon (Dashboard UI) - (always use the trunk)
ENABLED_SERVICES+=,horizon
HORIZON_REPO=https://github.com/openstack/horizon
HORIZON_BRANCH=master

# Nova - Compute Service
ENABLED_SERVICES+=,n-api,n-crt,n-obj,n-cpu,n-cond,n-sch

######vnc
ENABLED_SERVICES+=,n-novnc,n-xvnc


IMAGE_URLS+=",https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"
#IMAGE_URLS+=",http://172.28.0.1/image/cirros-0.3.0-x86_64-disk.img"


# Nova Network - If you don't want to use Neutron and need a simple network setup (old good stuff!)
#ENABLED_SERVICES+=,n-net

## Nova Cells
ENABLED_SERVICES+=,n-cell

# Glance - Image Service
ENABLED_SERVICES+=,g-api,g-reg

# Swift - Object Storage
#ENABLED_SERVICES+=,s-proxy,s-object,s-container,s-account

# Neutron - Networking Service
# If Neutron is not declared the old good nova-network will be used
ENABLED_SERVICES+=,q-svc,q-agt,q-dhcp,q-l3,q-meta,neutron

## Neutron - Load Balancing
#ENABLED_SERVICES+=,q-lbaas

## Neutron - VPN as a Service
#ENABLED_SERVICES+=,q-vpn

## Neutron - Firewall as a Service
#ENABLED_SERVICES+=,q-fwaas

# VLAN configuration
#Q_PLUGIN=ml2
#ENABLE_TENANT_VLANS=True

# GRE tunnel configuration
Q_PLUGIN=ml2
ENABLE_TENANT_TUNNELS=True

# VXLAN tunnel configuration
#Q_PLUGIN=ml2
#Q_ML2_TENANT_NETWORK_TYPE=vxlan   

# Cinder - Block Device Service
#VOLUME_GROUP="cinder-volumes"
#ENABLED_SERVICES+=,cinder,c-api,c-vol,c-sch,c-bak

# Heat - Orchestration Service
ENABLED_SERVICES+=,heat,h-api,h-api-cfn,h-api-cw,h-eng
#IMAGE_URLS+=",http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2"

# Ceilometer - Metering Service (metering + alarming)
ENABLED_SERVICES+=,ceilometer-acompute,ceilometer-acentral,ceilometer-collector,ceilometer-api
ENABLED_SERVICES+=,ceilometer-alarm-notify,ceilometer-alarm-eval

# Apache fronted for WSGI
#APACHE_ENABLED_SERVICES+=keystone,swift
APACHE_ENABLED_SERVICES+=keystone

http://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/14.04/ubuntu-14.04-desktop-amd64.iso
