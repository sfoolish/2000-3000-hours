---
## Native Linux KVM tool
### LKVM 测试运行
    $ sudo apt-get install kvm ubuntu-virt-server kvm-ipxe
    $ git clone git://github.com/penberg/linux-kvm.git
    $ cd linux-kvm
    $ make x86_64_defconfig
    $ cp .config confif_x64_def
    $ make menuconfig
    $ diff .config confif_x64_def  | grep '=y'
    ```
        < CONFIG_KVMTOOL_TEST_ENABLE=y   # 选上这个下面的选项默认都会选上
        < CONFIG_NET_9P=y
        < CONFIG_NET_9P_VIRTIO=y
        < CONFIG_VIRTIO_BLK=y
        < CONFIG_VIRTIO_NET=y
        < CONFIG_CONSOLE_POLL=y
        < CONFIG_HVC_DRIVER=y
        < CONFIG_VIRTIO_CONSOLE=y
        < CONFIG_VIRTIO=y
        < CONFIG_VIRTIO_PCI=y
        < CONFIG_9P_FS=y
        < CONFIG_KGDB=y
        < CONFIG_KGDB_SERIAL_CONSOLE=y
     ```
    $ make -j4
    $ cd tools/kvm/
    $ make -j4
    $ wget http://wiki.qemu.org/download/linux-0.2.img.bz2
    $ bunzip2 linux-0.2.img.bz2
    $ sudo ./lkvm  run -d linux-0.2.img 
### LKVM 网络功能的使用
    $ sudo ./lkvm run  -d domU-x86_64-FS.img --network virtio
虚拟机正常起来后，主机会生成 tap0 虚拟网卡，将虚拟机中的网卡的 ip 和 tap0 的 ip 设到同一网段，主/虚拟机间的网络就通了。
#### TUN/TAP 相关概念
In computer networking, TUN and TAP are virtual network kernel devices. They are network devices that are supported entirely in software, which is different from ordinary network devices that are backed up by hardware network adapters.

TAP (as in [network tap](https://en.wikipedia.org/wiki/Network_tap)) simulates a link layer device and it operates with layer
2 packets such as Ethernet frames. TUN (as in network TUNnel) simulates a
network layer device and it operates with layer 3 packets such as IP packets.
TAP is used to create a network bridge, while TUN is used with routing.
### LKVM kgdb 内核调试
添加kgdb 相关启动参数，启动内核：

    $ sudo ./lkvm run -p "kgdboc=ttyS1 kgdbwait" --tty 1 -d domU-x86_64-FS.img 

虚拟机系统起来之后，可以通过一下命令，让目标系统进入调试模式：

    $ echo g >| /proc/sysrq-trigger
主机通过下面命令链接虚拟机，进行调试：

    $ sudo gdb ../../vmlinux
    $ target remote /dev/pts/1
### REF
* [Native Linux KVM tool v2](http://lwn.net/Articles/447556/)
* [[ANNOUNCE] Native Linux KVM tool](http://amosk.info/blog/?p=622)
* [lkvm github](https://github.com/penberg/linux-kvm)
* [lkvm Documentation](https://github.com/penberg/linux-kvm/tree/master/tools/kvm/Documentation)
* [domU-x86_64-FS.img](http://cloudxy.googlecode.com/files/domU-x86_64-FS.img2.zip)
* [TUN/TAP wiki](https://en.wikipedia.org/wiki/TUN/TAP)
* [kernel-debugging.txt](https://github.com/penberg/linux-kvm/blob/master/tools/kvm/Documentation/kernel-debugging.txt)

---
## rootfs img 文件使用
### 方法1：
    $ mkdir sf
    $ sudo losetup /dev/loop0 domU-x86_64-FS.img 
    $ mount /dev/loop0 sf
    $ sudo mount /dev/loop0 sf
    $ sudo umount sf
    $ sudo losetup -d /dev/loop0
    $ rm -rf sf
### 方法2：
    $ mkdir sf
    $ sudo mount -o loop domU-x86_64-FS.img sf/
    $ sudo umount sf
    $ rm -rf sf

在使用domU-x86_64-FS.img时遇到`echo` 无法写文件的问题。查了一下需要下面这个命令。

	# set +o noclobber
因为"/etc/profile"中有下面这么一行：`set -o noclobber`。noclobber 这个选项，告诉bash在重定向的时候，不要覆盖已有文件。在设定了noclobber之后,如何强制覆盖现有文件 `echo hello >| abc`。
## REF
* [domU-x86_64-FS.img](https://cloudxy.googlecode.com/files/domU-x86_64-FS.img2.zip)

---
## domU-x86_64-FS.img 修改
### lkvm 运行异常打印修改
使用默认的 domU-x86_64-FS.img ，系统启动后，会一直有如下打印：

    ```
        can't open /dev/hvc0: No such file or directory
    ```
将文件系统做如下修改：
    
    ## 挂载文件系统
    $ mkdir sf
    $ sudo mount -o loop domU-x86_64-FS.img sf/
    ## 查找配置文件
    $ cd sf/etc/
    $ sudo grep -rn hvc ./
    ```
        ./inittab:30:hvc0::respawn:/sbin/getty 38400 hvc0
        ./securetty:20:hvc0
    ```
    ## 修改配置文件
    $ sudo vim inittab +30
    ```
        #hvc0::respawn:/sbin/getty 38400 hvc0     # sfoolish command out
    ```
    ## 卸载文件系统
    $ sudo umount sf
    $ rm -rf sf
### 默认挂载 nfs 文件系统
    ## 编辑 domU-x86_64-FS.img 配置脚本
    vim /etc/profile.d/sf_config.sh
    ```
        ifconfig eth0 192.168.33.2 netmask 255.255.255.0
        ## 判读 /mnt/tools 是否为空，避免重复挂载
        if [[ "`ls -A /mnt/tools`" = "" ]]; then
            mount -t nfs -o nolock 192.168.33.1:/home/liang/prj/kvm/tools /mnt/tools
        fi
        export PATH=$PATH:/mnt/tools/bin
    ```
用户登入的时候会自动执行 `/etc/profile` 脚本，`/etc/profile` 最后有如下语句

    ```
        for i in /etc/profile.d/*.sh; do
            [[ -f $i ]] && . $i  
    ```
### domU-32bit-FS.img ssh 登陆异常处理
    ## 运行 lkvm
    $ sudo ./lkvm  run -d domU-32bit-FS.img --network virtio
    ## 设置虚拟机ip
    # ifconfig eth0 192.168.33.2 netmask 255.255.255.0
    ## 主机登陆虚拟机异常
    $ ssh root@192.168.33.2
    ```
        root@192.168.33.2's password: 
        PTY allocation request failed on channel 0
        shell request failed on channel 0
    ```

    ## 方法一：
    ## ssh 登陆后开启交互式 bash
    $ ssh root@192.168.33.2 "/bin/bash -i"
    ```
        root@192.168.33.2's password: 
        bash-3.2# pwd
        /root
        bash-3.2# 
    ```
    ## 方法二：
    ## 虚拟机设置 /dev/pts
    # mkdir /dev/pts 
    # mount -t devpts devpts /dev/pts
    $ ssh root@192.168.33.2
    ```
        root@192.168.33.2's password: 
        % 
    ```
#### REF
* [PTY allocation request failed on channel 0 ](http://ejkill.blog.163.com/blog/static/10774945200911135149719/)
* [domU-32bit-FS.img.tgz](https://cloudxy.googlecode.com/files/domU-32bit-FS.img.tgz)

---
## [KVM虚拟化原理与实践（连载）](http://smilejay.com/kvm_theory_practice/)

---
## qemu mac osx 10.6 下编译
    $ ./configure --disable-aio --disable-kvm  --disable-sdl --target-list=i386-softmmu --disable-sdl --prefix=/Users/apple/APP_PRJ/e_vm/qemu/install
    $ make -j4
    $ make install
    $ wget http://wiki.qemu.org/download/linux-0.2.img.bz2
    $ ./qemu linux-0.2.img

在 qemu 中按 ctrl+alt+2 切换到qemu monitor模式，ctrl-alt 主机/虚拟机鼠标切换。

### REF
* [qemu](http://wiki.qemu.org)
* [qemu-github](https://github.com/qemu/QEMU)
* [qemu-wiki](http://wiki.qemu.org/Links)
* [使用 QEMU 进行系统仿真](http://www.ibm.com/developerworks/cn/linux/l-qemu/)
* [qemu compilation](http://qemu.weilnetz.de/qemu-doc.html#compilation)
The Mac OS X patches are not fully merged in QEMU, so you should look at the QEMU mailing list archive to have all the necessary information. 
* [Virtual Development Board](http://www.elinux.org/Virtual_Development_Board)
* [How to install Qemu on MAC OSX 10.6 & 10.7](http://forum.gns3.net/topic4600.html)
* [QEMU/Monitor](http://en.wikibooks.org/wiki/QEMU/Monitor)
The monitor is accessed from within QEMU by holding down the Control and Alt keys, and pressing Shift-2. Once in the monitor, Shift-1 switches back to the guest OS.
* [Comparison of platform virtual machines](http://en.wikipedia.org/wiki/Comparison_of_platform_virtual_machines)

---
## Bochs
* [Bochs 简介及配置](http://www.cppblog.com/coreBugZJ/archive/2011/04/03/143334.aspx)
* [如何在macosx上通过源码安装bochs2.4.6并使用peter-bochs进行调试](http://blog.csdn.net/bigstaff/article/details/6311926)
* [oldlinux bochs](http://oldlinux.org/Linux.old/)

---

## SPICE
[spice documentation](http://spice-space.org/documentation.html)
[DeveloperStartPage](http://spice-space.org/page/DeveloperStartPage)

[红帽桌面虚拟化：SPICE协议的优势](http://www.searchvirtual.com.cn/showcontent_54562.htm) 思杰是该领域领导者（尤其是ICA/HDX），不过VMware View最新的版本5中的PCoIP协议也很有竞争力。微软最近也在大量宣传RDP附件RemoteFX。

---

### qemu-kvm
  391  sudo apt-get install ubuntu-virt-server python-vm-builder
  392  sudo apt-get install ubuntu-virt-server python-vm-builder kvm-ipxe virt-manager
  393  id -un
  394  id -nu
  395  adduser `id -un` libvirtd
  396  sudo adduser `id -un` libvirtd
  397  sudo adduser `id -un` kvm
  398  exit
  399  virsh -c qemu:///system list
  400  sudo apt-get install bridge-utils
  401  ifconfig 

sudo apt-get install qemu-kvm libvirt-bin virt-manager bridge-utils

[Debian Lenny and Squeeze amd64 images for QEMU or KVM](http://people.debian.org/~aurel32/qemu/amd64/)
[[ANNOUNCE] Native Linux KVM tool](http://amosk.info/blog/?p=622)


---
## [Nested Virtualization: VT-in-VT](https://www.virtualbox.org/ticket/4032)

```bash
#Unload and reload kvm-intel kernel module with nested support.
modprobe -r kvm-intel
modprobe kvm-intel nested=1
cat /sys/module/kvm_intel/parameters/nested
Y (Y for yes)

echo 'options kvm_intel nested=1' >> /etc/modprobe.d/qemu-system-x86.conf
```


* [How to Enable Nested KVM](http://www.rdoxenham.com/?p=275)

Centos 7 下 vm 的 libvirt xml 还需要添加 vmx 相关设置，起来的 vm 才支持虚拟化指令集

```xml
<cpu match='exact'>
  <model>Westmere</model>
 <feature policy='require' name='vmx'/>
</cpu>
```

```xml
<cpu mode='host-passthrough'/>
```

* [CPU model and topology](https://libvirt.org/formatdomain.html#elementsCPU)
* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-libvirt-dom-xml-cpu-model-top.html

