## heat-2014.2.1 代码行分析

### 代码版本下载

- 方法一： 到 https://github.com/openstack/heat/releases 下载相应版本压缩包，这里是2014.2.1
- 方法二： git 命令下载，好处是带详细的代码更新记录
	
	git clone https://github.com/openstack/heat.git
	到 https://github.com/openstack/heat/releases 查看相应版本的 Change-Id，这里是 f2c73c650b16f26eece1841552e0c276b9d954df
	cd heat
	git checkout f2c73c650b16f26eece1841552e0c276b9d954df

---

### 代码整体统计

分析脚本：

	for i in api cloudinit cmd common db engine openstack rpc scaling tests .
	do
		echo -e "$i"
		find $i -name "*.py" | xargs wc -l | grep total
	done

结果整理：
	
	api    		4055 
	cloudinit   146
	cmd	        91
	common		3920
	db    		3450
	engine   	29398
	openstack   5843
	rpc         774
	scaling     100
	tests       71080
	.			118896

---
### engine 代码统计

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/engine
$ ls *.py | xargs wc -l | sort
       0 __init__.py
      21 parser.py
      36 support.py
      46 timestamp.py
      53 lifecycle_plugin.py
      69 parameter_groups.py
     101 signal_responder.py
     102 event.py
     116 plugin_manager.py
     153 stack_lock.py
     163 stack_user.py
     169 function.py
     198 update.py
     200 attributes.py
     217 template.py
     248 dependencies.py
     367 stack_resource.py
     389 api.py
     390 watchrule.py
     403 rsrc_defn.py
     450 environment.py
     504 properties.py
     516 scheduler.py
     533 parameters.py
     581 constraints.py
     1108 stack.py
     1125 resource.py
     1475 service.py
    9733 total

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/heat/engine/resources
$ find ./ -name  "*.py" | xargs wc -l | sort
       0 .//aws/__init__.py
       0 .//ceilometer/__init__.py
       0 .//neutron/__init__.py
       0 .//openstack/__init__.py
       0 .//software_config/__init__.py
      25 .//iso_8601.py
      60 .//software_config/cloud_config.py
      71 .//nova_servergroup.py
      88 .//__init__.py
     119 .//stack.py
     125 .//glance_image.py
     131 .//vpc.py
     132 .//subnet.py
     134 .//neutron/provider_net.py
     138 .//internet_gateway.py
     146 .//nova_keypair.py
     156 .//software_config/multi_part.py
     160 .//software_config/software_component.py
     165 .//aws/scaling_policy.py
     165 .//nova_floatingip.py
     167 .//openstack/scaling_policy.py
     170 .//neutron/metering.py
     172 .//s3.py
     177 .//route_table.py
     178 .//network_interface.py
     179 .//neutron/net.py
     185 .//sahara_cluster.py
     185 .//swift.py
     188 .//software_config/software_config.py
     190 .//neutron/neutron.py
     192 .//software_config/structured_config.py
     193 .//cloud_watch.py
     205 .//aws/launch_config.py
     233 .//neutron/subnet.py
     238 .//neutron/security_group.py
     250 .//neutron/network_gateway.py
     264 .//template_resource.py
     266 .//neutron/floatingip.py
     274 .//resource_group.py
     280 .//random_string.py
     281 .//security_group.py
     305 .//user.py
     317 .//ceilometer/alarm.py
     319 .//swiftsignal.py
     331 .//neutron/port.py
     337 .//sahara_templates.py
     367 .//neutron/router.py
     395 .//nova_utils.py
     396 .//neutron/firewall.py
     428 .//eip.py
     486 .//os_database.py
     495 .//wait_condition.py
     546 .//loadbalancer.py
     608 .//software_config/software_deployment.py
     690 .//neutron/vpnservice.py
     713 .//neutron/loadbalancer.py
     785 .//volume.py
     859 .//autoscaling.py
     968 .//instance.py
     1137 .//server.py
    16764 total

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/heat/engine/clients
$ find ./ -name  "*.py" | xargs wc -l | sort
       0 .//os/__init__.py
      31 .//os/keystone.py
      45 .//os/sahara.py
      49 .//os/ceilometer.py
      53 .//os/cinder.py
      62 .//os/heat_plugin.py
      74 .//os/trove.py
      90 .//client_plugin.py
     109 .//os/glance.py
     115 .//os/swift.py
     159 .//__init__.py
     159 .//os/neutron.py
     406 .//os/nova.py
    1352 total

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/heat/engine/cfn
$ find ./ -name  "*.py" | xargs wc -l | sort
       0 .//__init__.py
     181 .//template.py
     559 .//functions.py
    740 total

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/heat/engine/hot
$ find ./ -name  "*.py" | xargs wc -l | sort
       0 .//__init__.py
     141 .//parameters.py
     263 .//functions.py
     273 .//template.py
    677 total

ϟSF-Hacking: ~/1_app_prj/2_OpenStack/3_heat/heat/heat/engine/notification
$ find ./ -name  "*.py" | xargs wc -l | sort
      39 .//stack.py
      41 .//autoscaling.py
      52 .//__init__.py
    132 total

