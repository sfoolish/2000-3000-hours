## [Running OpenStack under VirtualBox](http://uksysadmin.wordpress.com/2011/02/15/running-openstack-under-virtualbox/)

Intel VT-x: KVM does NOT currently support nested virtualization
To run instances under OpenStack under VirtualBox, you must specify that software emulation be used

sudo apt-get install qemu
Edit /etc/nova/nova.conf to enable qemu (software virtualization) support

--libvirt_type=qemu

[How to enable nested virtualization in ubuntu](http://askubuntu.com/questions/328748/how-to-enable-nested-virtualization-in-ubuntu)

run another hypervisor inside VirtualBox (e.g. VirtualBox inside VirtualBox). This option will be very slow, because the guest will miss VT-X/AMD-V.


[Nested Virtualization: VT-in-VT](https://www.virtualbox.org/ticket/4032)


[Nested KVM Hypervisor Support](http://networkstatic.net/nested-kvm-hypervisor-support/)

qemu命令行参数转libvirt的xml文件
http://www.chenyudong.com/archives/qemu-kvm-command-arguments-switch-to-libvirt-xml.html

/usr/bin/qemu-system-x86_64 --enable-kvm \
  -m 1024 \
  -smp 1 \
  -name QEMUGuest1 \
  -nographic \
  -monitor pty -no-acpi -boot c \
  -drive  file=/dev/HostVG/QEMUGuest1,if=ide,index=0 \
  -net none \
  -serial none -parallel none -usb

http://networkstatic.net/openstack-quantum-devstack-on-a-laptop-with-vmware-fusion/
VMware Fusion and VMware Workstation both support nested virtualization.

[VMWARE FUSION 6 KEY](http://www.macx.cn/thread-2102701-1-1.html)
Serial number: VZ15K-DKD85-M85EP-W4P79-XAAU4 
Serial number: VU50A-2UW9Q-M88UY-D7MQX-ZG8X8 
Serial number: VG7WU-41G97-48D8Y-X5PQZ-MLHZA 
Serial number: VA5MK-49E1H-488NP-ENXXG-M28X6 
Serial number: YZ3TU-AHWE2-0892Q-YWYET-Q7UDD 
Serial number: GV5DK-8RDDJ-484GQ-FZNNG-Y2UYA 
Serial number: CU74A-6ZE0J-489WP-YXZ59-W70W2 
Serial number: CG500-47EEM-08EAQ-GGW7Z-QP2VD 
Serial number: CF7X2-FFFEP-48DQZ-ZFQEE-QAUVF 
Serial number: GV1MA-DPW57-0894Y-H4NZT-X6KC2