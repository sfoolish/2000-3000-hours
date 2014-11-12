
## [Nova虚拟机创建流程](http://www.aikaiyuan.com/7617.html)

1. 创建流程

本次分析主要从Nova.compute.manger入手，对于创建虚拟机的API请求以及调度不做分析。创建虚拟机入口函数为_run_instance，manger中driver初始化是根据配置文件中的配置信息，默认为compute_driver = libvirt.LibvirtDriver。具体函数调用关系如下图。


    +---------------------+                                      
    |buildinstance        |                                      
    +---+-----------------+          
     |        +--------------------+                           
     +--------| _prebuild_instance |                           
     |        +--------------------+                                                                         
     |        +--------------------+                           
     +--------| _build_instance    |                           
              +-+------------------+                                                            
                |   +--------------------------------------+     
                +---| network_info = self._allocate_network|     
                |   +--------------------------------------+  
                |   +--------------------------------------------+
                +---| block_de|ice_info = self._prep_block_device|
                |   +--------------------------------------------+
                |   +------------------------------------------+
                +---| instance = self._spawn                   |
                    +-+----------------------------------------+
                      |  +------------------+                    
                      +--|self.driver.spawn |                    
                         ++-----------------+                                                         
                          |  +--------------+                     
                          +--| _create_image|                     
                          |  +--------------+ 
                          |  +--------------+                     
                          +--| to_xml       |                     
                          |  +--------------+  
                          |  +--------------+-------------+       
                          +--| _create_domain_and_network |       
                          |  +----------------------------+ 
                          |  +----------------+                   
                          +--| Wait for boot  |                   
                             +----------------+

创建虚拟机流程分为以下大的3步：

（1） 申请网络：_allocate_network
（2） 准备块存储设备：_prep_block_device
（3） 调用driver创建虚拟机：spawn

2. 状态图

创建虚拟机过程，VM State、Task State、Power State如下图所示，虚拟机的状态始终未building，任务状态发生了三次改变。

3 block_device_info

在prep_block_device函数中，会调用Cinder的initialize_connection()和attach()，返回值为block_device_info。函数执行完后，卷会挂载到本地，供虚拟机使用。

(1)从镜像启动虚拟机block_device_info值为：

    {
        'block_device_mapping': [],
        'root_device_name': '/dev/vda', 
        'ephemerals': [], 
        'swap': None
    }
 

(2)从硬盘启动block_device_info值为：

    {
        'block_device_mapping': [{
            'guest_format': None, 
            'boot_index': 0, 
            'mount_device': u'vda', 
            'connection_info':{
                'driver_volume_type': u'iscsi', 
                'serial': u'8fc07771-130e-4fc4-8cb0-0d47bc316cd4', 
                'data': {
                    u'access_mode': u'rw', 
                    u'target_discovered': False, 
                    u'encrypted': False, 
                    u'qos_spec': None, 
                    u'target_iqn': u'iqn.2010-10.org.openstack:volume-8fc07771-130e-4fc4-8cb0-0d47bc316cd4', 
                    u'target_portal': u'186.100.21.222:3260',
                    u'volume_id': u'8fc07771-130e-4fc4-8cb0-0d47bc316cd4', 
                    u'target_lun': 1, 
                    u'auth_password': u'2goCZgd7Wb7sLwLBhA73', 
                    u'auth_username': u'2sXoCUUoZcpajxK2L7T8', 
                    u'auth_method': u'CHAP'
                  }
            },
           'disk_bus': None, 
           'device_type': None,
           'delete_on_termination': False
        }], 
        'root_device_name': u'vda', 
        'ephemerals': [], 
        'swap': None
    }
