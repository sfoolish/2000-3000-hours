# http://docs.openstack.org/kilo/install-guide/install/apt/content/

sudo su

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

if [ ! -f /etc/apt/sources.list_bkp ]; then
    cp /etc/apt/sources.list /etc/apt/sources.list_bkp
fi

cat > /etc/apt/sources.list << EOF
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
EOF


apt-get install ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
 "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list

curl -O https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
echo "deb http://www.rabbitmq.com/debian/ testing main" \
> /etc/apt/sources.list.d/rabbitmq.list

apt-get update && apt-get dist-upgrade

apt-get install -y --force-yes mariadb-server python-mysqldb
apt-get install -y --force-yes rabbitmq-server
apt-get install -y --force-yes keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache
apt-get install -y --force-yes glance python-glanceclient
apt-get install -y --force-yes nova-api nova-cert nova-conductor nova-consoleauth \
 nova-novncproxy nova-scheduler python-novaclient
apt-get install -y --force-yes nova-compute sysfsutils
apt-get install -y --force-yes neutron-server neutron-plugin-ml2 python-neutronclient
apt-get install -y --force-yes neutron-plugin-ml2 neutron-plugin-openvswitch-agent \
 neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
apt-get install -y --force-yes neutron-plugin-ml2 neutron-plugin-openvswitch-agent
apt-get install -y --force-yes nova-network nova-api-metadata
apt-get install -y --force-yes openstack-dashboard
apt-get install -y --force-yes cinder-api cinder-scheduler python-cinderclient
apt-get install -y --force-yes lvm2
apt-get install -y --force-yes cinder-volume python-mysqldb
apt-get install -y --force-yes heat-api heat-api-cfn heat-engine python-heatclient
apt-get install -y --force-yes mongodb-server mongodb-clients python-pymongo
apt-get install -y --force-yes ceilometer-api ceilometer-collector ceilometer-agent-central \
 ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier \
 python-ceilometerclient
apt-get install -y --force-yes ceilometer-agent-compute

