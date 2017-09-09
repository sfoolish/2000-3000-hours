## Collectd

* [Collectd 101](https://wiki.opnfv.org/display/fastpath/Collectd+101)
* [collectd offical doc](https://collectd.org/documentation.shtml)
* [How To Configure Collectd to Gather System Metrics for Graphite on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-configure-collectd-to-gather-system-metrics-for-graphite-on-ubuntu-14-04)
* [使用 collectd 进行服务监控](http://blog.kankanan.com/article/4f7f7528-collectd-8fdb884c670d52a176d163a7.html)

###  collectd 的简易安装方式及使用

#### 配置本地镜像源（optional）

```bash
cat << "EOF" > /etc/apt/sources.list
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial main restricted
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial-updates main restricted
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial universe
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial-updates universe
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial multiverse
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial-updates multiverse
deb http://192.168.21.2:8888/mirror/archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse
deb http://192.168.21.2:8888/mirror/security.ubuntu.com/ubuntu xenial-security main restricted
deb http://192.168.21.2:8888/mirror/security.ubuntu.com/ubuntu xenial-security universe
deb http://192.168.21.2:8888/mirror/security.ubuntu.com/ubuntu xenial-security multiverse
EOF
```

#### 安装 collectd

```bash
apt-get update
apt-get install -y collectd collectd-utils
```

```console
root@vm1:/etc/collectd# ls
collectd.conf  collectd.conf.d  collection.conf

root@vm1:/etc/collectd# cat collection.conf
datadir: "/var/lib/collectd/rrd/"
libdir: "/usr/lib/collectd/"

root@vm1:/etc/collectd# ls /var/lib/collectd/rrd/vm1/
cpu-0  cpu-2  df-root   disk-vda   disk-vdb  entropy         interface-ens4  irq   memory     swap
cpu-1  cpu-3  disk-sr0  disk-vda1  disk-vdc  interface-ens3  interface-lo    load  processes  users
```

默认安装后为单机版，将监控结果存放在 /var/lib/collectd/rrd/，collectd 的原生插件存放在路径 /var/lib/collectd/rrd/vm1/ 下

#### 安装 collectd 前端

```bash
apt-get install -y apache2
# cgp is implemented in php
apt-get install -y php libapache2-mod-php

cd /var/www/html
wget https://github.com/pommi/CGP/archive/v1.tar.gz
tar xf v1.tar.gz
mv CGP-1/ cgp
```

* Collectd Graph Panel 的官方代码路径： https://github.com/pommi/CGP
* Apache 默认静态文件路径：/var/www/html
* CGP 的配置文件路径在：/var/www/html/cgp/conf/config.php

### collectd 的集群化复杂使用场景的常见安装配置方式

#### 多机监控

* [使用 collectd 进行服务监控](http://blog.kankanan.com/article/4f7f7528-collectd-8fdb884c670d52a176d163a7.html)

- server 汇聚端 collectd.conf 配置

```console
LoadPlugin network

<Plugin network>
    <Listen "0.0.0.0" "25826">
        SecurityLevel Sign
        AuthFile "/etc/collectd/passwd"
    </Listen>
</Plugin>
```

密码文件：/etc/collectd/passwd

```console
user0: foo
user1: bar
```

- client 端 collectd.conf 配置

```console
LoadPlugin network

<Plugin network>
    <Server "172.17.0.1" "25826">
        SecurityLevel Encrypt
        Username "user0"
        Password "foo"
    </Server>
</Plugin>
```

#### Grafana＋collectd＋InfluxDB

* [使用 Grafana＋collectd＋InfluxDB 打造现代监控系统](http://www.vpsee.com/2015/03/a-modern-monitoring-system-built-with-grafana-collected-influxdb/)

### collectd 的源码编译安装

* https://github.com/chenryn/logstash-best-practice-cn/blob/master/input/collectd.md

```bash
wget http://collectd.org/files/collectd-5.4.1.tar.gz
tar zxvf collectd-5.4.1.tar.gz
cd collectd-5.4.1
apt-get install -y gcc make
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib --mandir=/usr/share/man --enable-all-plugins
make && make install
```

### collectd

* collectd 的代码解析
    - collectd 的插件机制
    - collectd 的几个关键插件
    - collectd 的python版插件机制
* collectd 如何实现简易插件
* [Collectd advantages, disadvantages and a few asides](https://wiki.opnfv.org/display/fastpath/Collectd+advantages%2C+disadvantages+and+a+few+asides)
* https://en.wikipedia.org/wiki/Comparison_of_network_monitoring_systems
