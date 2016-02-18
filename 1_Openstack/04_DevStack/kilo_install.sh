#!/bin/bash
############################################
#stack information
newpassword=password
CONTROLLER_IP=10.0.0.11
ADMIN_TOKEN=$newpassword
SERVICE_PWD=$newpassword
ADMIN_PWD=$newpassword
META_PWD=$newpassword

echo "$(tput setaf 1)STARTING OPENSTACKING INSTALL$(tput sgr0)"

#Changing NIC cards
#echo "$(tput setaf 1)NICS  CHANGED$(tput sgr0)"
#echo "auto eth1" >> /etc/network/interfaces
#echo "iface eth1 inet manual" >> /etc/network/interfaces
#echo "        up ip link set dev $IFACE up" >>/etc/network/interfaces
#echo "        down ip link set dev $IFACE down" >>/etc/network/interfaces
#echo " " >> /etc/network/interfaces
#echo "auto eth2" >> /etc/network/interfaces
#echo "iface eth2 inet dhcp" >> /etc/network/interfaces

#ifconfig eth1 up
#ifconfig eth2 up


#sets hosts file
sed -i "s/127.0.1.1/$CONTROLLER_IP/g" /etc/hosts
echo "$(tput setaf 1)HOST FILE CHANGED$(tput sgr0)"


#Package depandanies
echo "$(tput setaf 1)INSTALLING CORE DEPENDANCIES$(tput sgr0)"
apt-get install ntp -y
apt-get install crudini -y
apt-get install ubuntu-cloud-keyring -y
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
  "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
apt-get install vlan bridge-utils -y
apt-get update && apt-get dist-upgrade -y
echo "$(tput setaf 1)INSTALL CORE DEPENDANCIES COMPLETED$(tput sgr0)"

#Change forwarding
echo "$(tput setaf 1)CHANGING SYSCTL$(tput sgr0)"
sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sed -i -e 's/#net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=0/g' /etc/sysctl.conf
sed -i -e 's/#net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=0/g' /etc/sysctl.conf
sysctl -p
echo "$(tput setaf 1)SYSCTL CHANGED$(tput sgr0)"


#INSTALL RABBITMQ
echo "$(tput setaf 1)INSTALLING RABBITMQ$(tput sgr0)"
curl -O https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc
echo "deb http://www.rabbitmq.com/debian/ testing main" \
  > /etc/apt/sources.list.d/rabbitmq.list
apt-get update
apt-get install -y rabbitmq-server
rabbitmqctl change_password guest $SERVICE_PWD
rabbitmqctl add_user openstack $SERVICE_PWD
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
service rabbitmq-server restart
echo "$(tput setaf 1)RABBITMQ INSTALLED$(tput sgr0)"



#DATABASE INSTALL
echo "$(tput setaf 1)INSTALLING MYSQL$(tput sgr0)"


export MYSQL_ROOT_PASS=$SERVICE_PWD
export MYSQL_DB_PASS=$SERVICE_PWD

echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password seen true" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again seen true" | sudo debconf-set-selections


apt-get install mariadb-server python-mysqldb -y

#INSTALL DATABASE
echo "$(tput setaf 1)INSTALLING DATABASE$(tput sgr0)"
apt-get install -y mysql-server python-mysqldb
sed -i "s/bind-address.*/bind-address = $CONTROLLER_IP/" /etc/mysql/my.cnf
sed -i "s/^#max_connections.*/max_connections = 512/g" /etc/mysql/my.cnf

# UTF-8 Stuff
echo "[mysqld]
collation-server = utf8_general_ci
innodb_file_per_table
default-storage-engine = innodb
init-connect='SET NAMES utf8'
character-set-server = utf8" > /etc/mysql/conf.d/01-utf8.cnf

service mysql restart
echo "$(tput setaf 1)INSTALLED DATABASE$(tput sgr0)"


echo 'Enter the new MySQL root password'
mysql -u root -p$SERVICE_PWD <<EOF
CREATE DATABASE nova;
CREATE DATABASE cinder;
CREATE DATABASE glance;
CREATE DATABASE keystone;
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$SERVICE_PWD';
FLUSH PRIVILEGES;
EOF

#service mysql restart
echo "$(tput setaf 1)OPENSTACK DATABASES INSTALLED$(tput sgr0)"

###KEYSTONE INSTALL
echo "$(tput setaf 1)INSTALLING KEYSTONE$(tput sgr0)"
apt-get install -y keystone python-openstackclient
crudini --set /etc/keystone/keystone.conf DEFAULT admin_token $ADMIN_PWD
crudini --set /etc/keystone/keystone.conf database connection mysql://keystone:$ADMIN_PWD@$CONTROLLER_IP/keystone
crudini --set /etc/keystone/keystone.conf token provider keystone.token.providers.uuid.Provider
crudini --set /etc/keystone/keystone.conf token driver keystone.token.persistence.backends.sql.Token
crudini --set /etc/keystone/keystone.conf DEFAULT verbose true
su -s /bin/sh -c "keystone-manage db_sync" keystone

service keystone restart

rm -f /var/lib/keystone/keystone.db

(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
  echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
  >> /var/spool/cron/crontabs/keystone

sleep 5
echo "$(tput setaf 1)INSTALLED KEYSTONE SOFTWARE$(tput sgr0)"



#create keystone users and tenants
echo "$(tput setaf 1)CREATING KEYSTONE USERS AND TENANTS$(tput sgr0)"
export OS_TOKEN=$ADMIN_TOKEN
export OS_URL=http://$CONTROLLER_IP:35357/v2.0
sleep 5

openstack service create --type identity --description "OpenStack Identity" keystone

openstack endpoint create \
 --publicurl http://$CONTROLLER_IP:5000/v2.0 \
 --internalurl http://$CONTROLLER_IP:5000/v2.0 \
 --adminurl http://$CONTROLLER_IP:35357/v2.0 \
 --region RegionOne \
 identity

 

openstack project create --description "Admin Project" admin
openstack user create admin --password $newpassword
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password $newpassword demo
openstack role create _member_
openstack role add --project demo --user demo _member_
 

echo "$(tput setaf 1)CREATING KEYSTONE USERS AND TENANTS$(tput sgr0)"

#create credentials file
echo "export OS_PROJECT_DOMAIN_ID=default" > admin-openrc.sh
echo "export OS_USER_DOMAIN_ID=default" >> admin-openrc.sh
echo "export OS_PROJECT_NAME=admin" >> admin-openrc.sh
echo "export OS_TENANT_NAME=admin" >> admin-openrc.sh
echo "export OS_USERNAME=admin" >> admin-openrc.sh
echo "export OS_PASSWORD=$SERVICE_PWD" >> admin-openrc.sh
echo "export OS_AUTH_URL=http://$CONTROLLER_IP:35357/v3" >> admin-openrc.sh



unset OS_TOKEN OS_URL
source admin-openrc.sh

echo "$(tput setaf 1)CREDENTAILS FILE CREATED AND SOURCED$(tput sgr0)"


#create keystone entries for glance
echo "$(tput setaf 1)CREATING GLANCE USERS AND TENANTS AND CONF$(tput sgr0)"

openstack user create --password $SERVICE_PWD  glance
openstack role add --project service --user glance admin
openstack service create --type image --description "OpenStack Image service" glance

openstack endpoint create \
 --publicurl http://$CONTROLLER_IP:9292 \
 --internalurl http://$CONTROLLER_IP:9292 \
 --adminurl http://$CONTROLLER_IP:9292 \
 --region RegionOne \
 image


apt-get install glance python-glanceclient -y

crudini --set /etc/glance/glance-api.conf DEFAULT rabbit_host $CONTROLLER_IP
crudini --set /etc/glance/glance-api.conf DEFAULT rabbit_userid openstack
crudini --set /etc/glance/glance-api.conf DEFAULT rabbit_password $SERVICE_PWD
  
crudini --set /etc/glance/glance-api.conf database connection mysql://glance:$SERVICE_PWD@$CONTROLLER_IP/glance

crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://$CONTROLLER_IP:5000
crudini --set /etc/glance/glance-api.conf keystone_authtoken identity_uri http://$CONTROLLER_IP:35357
#crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
crudini --set /etc/glance/glance-api.conf keystone_authtoken admin_tenant_name service
crudini --set /etc/glance/glance-api.conf keystone_authtoken admin_user  glance
crudini --set /etc/glance/glance-api.conf keystone_authtoken admin_password $SERVICE_PWD

#crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
#crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
#crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
#crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
#crudini --set /etc/glance/glance-api.conf keystone_authtoken password $SERVICE_PWD

crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone
crudini --set /etc/glance/glance-api.conf glance_store default_store file
crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir  /var/lib/glance/images/
crudini --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-api.conf DEFAULT verbose True


###TEST
crudini --set /etc/glance/glance-registry.conf DEFAULT rabbit_host $CONTROLLER_IP
crudini --set /etc/glance/glance-registry.conf DEFAULT rabbit_userid openstack
crudini --set /etc/glance/glance-registry.conf DEFAULT rabbit_password $SERVICE_PWD

crudini --set /etc/glance/glance-registry.conf database connection mysql://glance:$SERVICE_PWD@$CONTROLLER_IP/glance
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$CONTROLLER_IP:5000
crudini --set /etc/glance/glance-registry.conf keystone_authtoken identity_uri http://$CONTROLLER_IP:35357
crudini --set /etc/glance/glance-registry.conf keystone_authtoken admin_tenant_name  service
crudini --set /etc/glance/glance-registry.conf keystone_authtoken admin_user  glance
crudini --set /etc/glance/glance-registry.conf keystone_authtoken admin_password  $ADMIN_PWD
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password

#crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken username glance
#crudini --set /etc/glance/glance-registry.conf keystone_authtoken password $SERVICE_PWD
crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
crudini --set /etc/glance/glance-registry.conf glance_store default_store file
crudini --set /etc/glance/glance-registry.conf glance_store filesystem_store_datadir  /var/lib/glance/images/
crudini --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
crudini --set /etc/glance/glance-registry.conf DEFAULT verbose True

su -s /bin/sh -c "glance-manage db_sync" glance

service glance-registry restart
service glance-api restart

rm -f /var/lib/glance/glance.sqlite

echo "$(tput setaf 1)CREATED GLANCE USERS AND TENANTS AND CONF$(tput sgr0)"
echo "export OS_IMAGE_API_VERSION=2" | tee -a admin-openrc.sh demoopenrc.sh
source admin-openrc.sh

sleep 5

wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
glance image-create --name "cirros-0.3.4-x86_64" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public --progress
echo "$(tput setaf 1)DEMO OS INSTALLED$(tput sgr0)"


echo "$(tput setaf 1)CONFIGURATING FOR NOVA$(tput sgr0)"
apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient nova-compute nova-console sysfsutils


openstack user create --password $SERVICE_PWD nova
openstack role add --project service --user nova admin
openstack service create --type compute --description "OpenStack Compute" nova
 
openstack endpoint create \
 --publicurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
 --internalurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
 --adminurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
 --region RegionOne \
 compute

# LOGS/STATE
crudini --set /etc/nova/nova.conf DEFAULT verbose True
crudini --set /etc/nova/nova.conf DEFAULT logdir /var/log/nova
crudini --set /etc/nova/nova.conf DEFAULT state_path /var/lib/nova
crudini --set /etc/nova/nova.conf DEFAULT lock_path /var/lock/nova
crudini --set /etc/nova/nova.conf DEFAULT rootwrap_config /etc/nova/rootwrap.conf

# SCHEDULER
crudini --set /etc/nova/nova.conf DEFAULT compute_scheduler_driver nova.scheduler.filter_scheduler.FilterScheduler

# COMPUTE
crudini --set /etc/nova/nova.conf DEFAULT compute_driver libvirt.LibvirtDriver
crudini --set /etc/nova/nova.conf DEFAULT api_paste_config /etc/nova/api-paste.ini
crudini --set /etc/nova/nova.conf DEFAULT instance_name_template BLKinstance-%08x

# RABBITMQ 
crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host $CONTROLLER_IP
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password $SERVICE_PWD
crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lock/nova

# NETWORK
crudini --set /etc/nova/nova.conf DEFAULT force_dhcp_release True
crudini --set /etc/nova/nova.conf DEFAULT my_ip $CONTROLLER_IP

crudini --set /etc/nova/nova.conf neutron network_api_class nova.network.neutronv2.api.API
crudini --set /etc/nova/nova.conf neutron neutron_url http://$CONTROLLER_IP:9696
crudini --set /etc/nova/nova.conf neutron neutron_auth_strategy keystone
crudini --set /etc/nova/nova.conf neutron neutron_admin_tenant_name service
crudini --set /etc/nova/nova.conf neutron neutron_admin_username neutron
crudini --set /etc/nova/nova.conf neutron neutron_admin_password $SERVICE_PWD
crudini --set /etc/nova/nova.conf neutron neutron_metadata_proxy_shared_secret $ADMIN_PWD
crudini --set /etc/nova/nova.conf neutron neutron_admin_auth_url http://$CONTROLLER_IP:35357/v2.0
crudini --set /etc/nova/nova.conf neutron linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
crudini --set /etc/nova/nova.conf neutron firewall_driver nova.virt.firewall.NoopFirewallDriver
crudini --set /etc/nova/nova.conf neutron security_group_api neutron
crudini --set /etc/nova/nova.conf neutron vif_plugging_is_fatal false
crudini --set /etc/nova/nova.conf neutron vif_plugging_timeout 0


# NOVNC CONSOLE
crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen $CONTROLLER_IP
crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address $CONTROLLER_IP
crudini --set /etc/nova/nova.conf DEFAULT novncproxy_base_url http://$CONTROLLER_IP:6080/vnc_auto.html

# AUTHENTICATION
crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone
crudini --set /etc/nova/nova.conf keystone_authtoken auth_host $CONTROLLER_IP
crudini --set /etc/nova/nova.conf keystone_authtoken auth_port 35357
crudini --set /etc/nova/nova.conf keystone_authtoken auth_protocol http
crudini --set /etc/nova/nova.conf keystone_authtoken admin_tenant_name service
crudini --set /etc/nova/nova.conf keystone_authtoken admin_user nova
crudini --set /etc/nova/nova.conf keystone_authtoken admin_password $ADMIN_PWD
crudini --set /etc/nova/nova.conf keystone_authtoken signing_dirname /tmp/keystone-signing-nova


# GLANCE
crudini --set /etc/nova/nova.conf glance api_servers $CONTROLLER_IP:9292
crudini --set /etc/nova/nova.conf glance host $CONTROLLER_IP

# DATABASE
crudini --set /etc/nova/nova.conf database connection mysql://nova:$SERVICE_PWD@$CONTROLLER_IP/nova

su -s /bin/sh -c "nova-manage db sync" nova

####finalize installation
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

rm -f /var/lib/nova/nova.sqlite

#source admin-openrc.sh
#SERVICE_TENANT_ID=$(keystone tenant-list | awk '/ service / {print $2}')


####Install and configure a compute node
echo "$(tput setaf 1)Install and configure a compute node$(tput sgr0)"
apt-get install nova-compute sysfsutils -y




##finalize installation
service nova-compute restart

rm -f /var/lib/nova/nova.sqlite

### Verify operation
#source admin-openrc.sh
nova service-list
nova endpoints
nova image-list

####alll good to here

####install the Networking components
echo "$(tput setaf 1)install the Networking components$(tput sgr0)"
apt-get install neutron-server neutron-plugin-ml2 python-neutronclient -y 
apt-get install neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent -y
#source admin-openrc.sh
###keystone or openstack

openstack user create --password $SERVICE_PWD neutron
openstack role add --project service --user neutron admin
openstack service create --type network --description "OpenStack Networking" neutron
openstack endpoint create \
 --publicurl http://$CONTROLLER_IP:9696 \
 --adminurl http://$CONTROLLER_IP:9696 \
 --internalurl http://$CONTROLLER_IP:9696 \
 --region RegionOne \
 network
 

crudini --set /etc/neutron/neutron.conf DEFAULT lock_path /var/lock/neutron
crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
crudini --set /etc/neutron/neutron.conf DEFAULT notification_driver neutron.openstack.common.notifier.rpc_notifier
crudini --set /etc/neutron/neutron.conf DEFAULT verbose True
crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_host $CONTROLLER_IP
crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_password $SERVICE_PWD
crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_userid openstack
crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True
crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone
crudini --set /etc/neutron/neutron.conf DEFAULT neutron_metadata_proxy_shared_secret $ADMIN_PWD
crudini --set /etc/neutron/neutron.conf DEFAULT service_neutron_metadata_proxy True
crudini --set /etc/neutron/neutron.conf DEFAULT nova_admin_password $SERVICE_PWD
crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes True
crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes True
crudini --set /etc/neutron/neutron.conf DEFAULT nova_admin_auth_url http://$CONTROLLER_IP:35357/v2.0
crudini --set /etc/neutron/neutron.conf DEFAULT nova_admin_tenant_id service
crudini --set /etc/neutron/neutron.conf DEFAULT nova_url http://$CONTROLLER_IP:8774/v2
crudini --set /etc/neutron/neutron.conf DEFAULT nova_admin_username nova

crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host $CONTROLLER_IP
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password $SERVICE_PWD

crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_host $CONTROLLER_IP
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_port 35357
crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_protocol http
crudini --set /etc/neutron/neutron.conf keystone_authtoken admin_tenant_name service
crudini --set /etc/neutron/neutron.conf keystone_authtoken admin_user neutron
crudini --set /etc/neutron/neutron.conf keystone_authtoken admin_password $SERVICE_PWD
####BUGS
#crudini --set /etc/neutron/neutron.conf keystone_authtoken signing_dir $state_path/keystone-signing 
#sed -i -e 's/#signing_dir/net.ipv4.conf.default.rp_filter=0/g' /etc/sysctl.conf
crudini --set /etc/neutron/neutron.conf database connection mysql://neutron:$SERVICE_PWD@$CONTROLLER_IP/neutron
###BUGS
#crudini --set /etc/neutron/neutron.conf agent root_helper sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf

crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types vlan,flat
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks External
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_vlan network_vlan_ranges Intnet1:100:200
#crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs bridge_mappings External:br-ex,Intnet1:br-int
#crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs bridge_mappings External:br-ex,Intnet1:br-eth1

crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_url http://$CONTROLLER_IP:5000/v2.0
crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_region RegionOne
crudini --set /etc/neutron/metadata_agent.ini DEFAULT admin_tenant_name service 
crudini --set /etc/neutron/metadata_agent.ini DEFAULT admin_user neutron
crudini --set /etc/neutron/metadata_agent.ini DEFAULT admin_password $SERVICE_PWD
crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret $ADMIN_PWD

crudini --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT use_namespaces True
crudini --set /etc/neutron/dhcp_agent.ini DEFAULT verbose True

crudini --set /etc/neutron/l3_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
crudini --set /etc/neutron/l3_agent.ini DEFAULT use_namespaces True

#######################BRIDGE CONFIGURATION

echo "$(tput setaf 1)CONFIGURATING OPENVSWITCH$(tput sgr0)"

ovs-vsctl add-br br-int
ovs-vsctl add-br br-eth2
ovs-vsctl add-br br-ex
#ovs-vsctl add-port br-eth2 eth2
#ovs-vsctl add-port br-ex eth1

neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

service neutron-server restart; service neutron-plugin-openvswitch-agent restart;service neutron-metadata-agent restart; service neutron-dhcp-agent restart; service neutron-l3-agent restart
echo "$(tput setaf 1)CONFIGURATING OPENVSWITCH AND NEUTRON COMPLETED$(tput sgr0)"
neutron agent-list

neutron net-create ext-net --router:external --provider:physical_network External --provider:network_type flat


#######################VIRTUAL CONFIGURATION
echo "$(tput setaf 1)CREATING VIRTUAL NETWORK CONF$(tput sgr0)"

neutron subnet-create ext-net --name ext-subnet \
  --allocation-pool start=192.168.3.150,end=192.168.3.180 \
  --disable-dhcp --gateway 192.168.3.1 192.168.3.0/24

neutron net-create internal-net
neutron subnet-create internal-net --name internal-subnet \
  --gateway 10.0.0.1 10.0.0.0/24

neutron router-create internal-router
neutron router-interface-add internal-router internal-subnet
neutron router-gateway-set internal-router ext-net

#######################HORIZON CONFIGURATION
echo "$(tput setaf 1)INSTALLING HORIZON AND CONF$(tput sgr0)"

apt-get install openstack-dashboard apache2 libapache2-mod-wsgi memcached python-memcache -y
apt-get remove --purge openstack-dashboard-ubuntu-theme -y





