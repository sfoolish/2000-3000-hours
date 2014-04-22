
## [Networking (Quantum)](http://en.wikipedia.org/wiki/OpenStack#Networking_.28Quantum.29)
OpenStack Networking (Quantum) is a pluggable, scalable[citation needed] and API-driven system for managing networks and IP addresses. Like other aspects of the cloud operating system, it can be used by administrators and users to increase the value of existing datacenter assets. OpenStack Networking ensures the network will not be the bottleneck or limiting factor in a cloud deployment and gives users real self service, even over their network configurations.

https://github.com/openstack-dev/devstack

---
# 2012-07-21

# MAC OS 10.6.8 上运行 nova 单元测试

## 运行环境
* MAC OS 10.6.8
* Xcode 4.0

## 说明
nova 现在只能在linux下运行，而且需要安装 libvirt 并且能够至少运行一种 hypervisors，Mac OS X 下只能运行单元测试。但是对与分析 nova 代码来说, 能够运行单元测试就方便了很多。

## 环境搭建过程

### easy_install 安装
    $ wget http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg#md5=bfa92100bd772d5a213eedd356d64086
    $ sudo sh setuptools-0.6c11-py2.6.egg 

### virtualenv 安装
    $ sudo easy_install virtualenv

### 代码获取
    $ git clone https://github.com/openstack/nova.git
    $ cd nova

### 单元测试安装
    $ vim run_tests.sh  # 导出ARCHFLAGS环境变量
    ```
		 export NOSE_OPENSTACK_STDOUT=1
		+export ARCHFLAGS='-arch i386 -arch x86_64'
		  
		 for arg in "$@"; do
	```
    $ sudo runtest_tests.sh
	```
		Running setup.py install for pycrypto
		configure: error: cannot find sources (src/pycrypto_compat.h) in /Users/apple/APP_PRJ/2_node/node or ..
		Traceback (most recent call last):
	```
    $ sudo ARCHFLAGS="-arch i386 -arch x86_64" python tools/install_venv.py
        # 在运行上面这条命令的时候，等./venv/build/pycrypto出来后，运行下面几条命令
        $ cd .venv/build/pycrypto
        $ sudo chmod 777 configure
        $ sudo ./configure
		```
			Nova development environment setup is complete.
		```
    $ sudo ./run_tests.sh 
    ```
        Slowest 5 tests took 14.53 secs:
            4.37    CloudTestCase.test_instance_initiated_shutdown_behavior
            3.19    ServersTest.test_create_multiple_servers
            2.62    ServersTest.test_deferred_delete
            2.39    ServersTest.test_create_and_rebuild_server
            1.96    CloudTestCase.test_stop_with_attached_volume
        ----------------------------------------------------------------------
        Ran 2986 tests in 346.856s
        
        FAILED (SKIP=6, failures=1)
    ```

## REF:
* [Setting Up a Development Environment](http://docs.openstack.org/developer/nova/devref/development.environment.html#mac-os-x-systems)
* [Unit Tests](http://docs.openstack.org/developer/nova/devref/unit_tests.html)
* [setuptools-0.6c11-py2.6.egg](http://pypi.python.org/pypi/setuptools#files)
* [Broken Pipe error when using pip to install pycrypto on Mac OS X](http://stackoverflow.com/questions/5944332/broken-pipe-error-when-using-pip-to-install-pycrypto-on-mac-os-x)
* [Python 2.6.1, pycrypto 2.3 pypi package: “Broken Pipe” during build](http://superuser.com/questions/259278/python-2-6-1-pycrypto-2-3-pypi-package-broken-pipe-during-build)

---
# 2012-06-25
国内加入openstack的公司有：
中国万网，新浪，趣游，H3C

国内方面，包括阿里巴巴集团旗下的万网等专业云计算服务提供商也纷纷加入OpenStack项目。
## [中国万网 - 阿里巴巴](http://www.gamewave.net/news/details-855.html)
中国万网是中国目前最大的域名注册服务商，阿里巴巴集团是中国目前最大的电子商务平台运营商。2009年9月，阿里巴巴集团向中国万网注入资金5.4亿，收购了中国万网85%股权，阿里巴巴集团成为了中国万网的第一大股东。且，同时，中国万网也成为阿里巴巴集团下即，阿里云、阿里妈妈、阿里学院、支付宝、淘宝网、淘宝商城、一淘网、阿里巴巴中国站、阿里巴巴国际站等分公司之后的，阿里巴巴另一家分公司。正式成为阿里巴巴集团下的子公司。

---
# 2012-04-14
[开源云计算技术OpenStack开发者大会](http://openstack.51qiangzuo.com/)
谁参加这个活动：
汪源 院长 公司： 网易杭州研究院
王磊 技术总监 公司： 网易杭州研究院

---

[db migrate script to set charset=utf8 for all tables](https://bugs.launchpad.net/glance/+bug/1279000)
[Change If887ac6b: Making DB sanity checking be optional for DB migration](https://review.openstack.org/#/c/75865/)



https://review.openstack.org/#/c/75865/

