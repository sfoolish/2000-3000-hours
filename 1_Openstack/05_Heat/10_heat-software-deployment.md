---
http://article.gmane.org/gmane.comp.cloud.openstack.devel/31332/match=qestions+adding+new+software

	> From: Tao Tao <ttao@...>
	> To: openstack-dev@...
	> Cc: Shu Tao <shutao@...>, Yan Yan YY Hu
	> <yanyanhu@...>, Bo B Yang <yangbbo@...>
	> Date: 01/08/2014 22:19
	> Subject: [openstack-dev] [HEAT] Qestions on adding a new Software
	> Config element for Opscode Chef
	>
	> Hi, All:
	>
	> We are trying to leverage Heat software config model to support
	> Chef-based software installation. Currently the chef-based software
	> config is not in place with Heat version 0.2.9.
	>
	> Therefore, we do have a number of questions on the implementation
	byourselves:
	>
	> 1. Should we create new software config child resource types (e.g.
	> OS::Heat::SoftwareConfig::Chef and
	> OS::Heat::SoftwareDeployment::Chef proposed in the https://
	> wiki.openstack.org/wiki/Heat/Blueprints/hot-software-config-spec) or
	> should we reuse the existing software config resource type (e.g.
	> OS::Heat::SoftwareConfig by leveraging group attribute) like the
	
	Right, you should not implement your own resource plugin, but use the
	current SoftwareConfig resource and specify 'chef' in the group attribute.
	
	无需像BP中描述的使用 OS::Heat::SoftwareConfig::Chef和OS::Heat::SoftwareDeployment::Chef资源，
	只需要使用当前的 SoftwareConfig 资源，并定义group属性为'chef'即可。
	image 的构建方法可见下面的链接：

	You will have to build an image that contains the right in-instance tools
	as described here:
	https://github.com/openstack/heat-templates/blob/master/hot/software-config/elements/README.rst
	
	Note that the in-instance hook for handling chef-solo is still in review
	and has not yet been merged to the heat-templates repository. Before
	building you image, you can pull the changes for the chef config hook from
	this review:
	
	https://review.openstack.org/#/c/80229/
	
	> following example with Puppet? What are the pros and cons with
	> either approach?
	>
	>   config:
	>     type: OS::Heat::SoftwareConfig
	>     properties:
	>       group: puppet
	>       inputs:
	>       - name: foo
	>       - name: bar
	>       outputs:
	>       - name: result
	>       config:
	>         get_file: config-scripts/example-puppet-manifest.pp
	>
	>   deployment:
	>     type: OS::Heat::SoftwareDeployment
	>     properties:
	>       config:
	>         get_resource: config
	>       server:
	>         get_resource: server
	>       input_values:
	>         foo: fooooo
	>         bar: baaaaa
	>
	> 2. Regarding OpsCode Chef and Heat integration, should our software
	> config support chef-solo only, or should support Chef server? In
	> another word,  should we let Heat to do the orchestration for the
	> chef-based software install or should we continue to use chef-server
	> for the chef-based software install?
	
	I would say, with the current chef in-instance hook for Heat, you could use
	chef-solo for the software install per package and per server and let Heat
	do the overall orchestration.
	
	>
	> 3. In the current implementation of software config hook for puppet
	> as follows:
	>
	> heat-templates / hot / software-config / elements / heat-config-puppet /
	> install.d / 50-heat-config-hook-puppet
	>
	> 3.1 why we need a 50-* as a prefix for the heat-config hook name?
	>
	> 3.2 In the script as follows, what is the "install-packages" script?
	> where does it load puppet package? How would we change the script to
	> install chef package?
	>
	> #!/bin/bash
	> set -x
	>
	> SCRIPTDIR=$(dirname $0)
	>
	> install-packages puppet
	> install -D -g root -o root -m 0755 ${SCRIPTDIR}/hook-puppet.py /var/
	> lib/heat-config/hooks/puppet
	>
	> 4. With diskimage-builder, we can build in images with many software
	> config elements(chef, puppet, script, salt), which means there will
	> be many hooks in the image.
	>  However, By reading the source code of the os-refresh-config, it
	> seems it will execute only the hooks which has corresponding "group"
	> defined in the software config, is that right?
	
	diskimage-builder 制作的 image,，包含很多 software 配置元素（chef, puppet, etc.）。这意味着镜像中安装了很多hooks。
	通过阅读 os-refresh-config 的源码，只有 software config 中 'group' 对应的 hook 才会被执行。
	
	Right, you have to have the group property in your SoftwareConfig resources
	set appropriately.
	
	>
	> def invoke_hook(c, log):
	>         # sanitise the group to get an alphanumeric hook file name
	>         hook = "".join(
	>             x for x in c['group'] if x == '-' or x == '_' or x.isalnum())
	>         hook_path = os.path.join(HOOKS_DIR, hook)
	>
	>         signal_data = None
	>         if not os.path.exists(hook_path):
	>             log.warn('Skipping group %s with no hook script %s' % (
	>                 c['group'], hook_path))
	>         else:
	>
	>
	> Thanks a lot for your kind assistance!
	>
	>


---

icehouse BP
https://blueprints.launchpad.net/heat/+spec/nova-server-rebuild
Nova has the capability to rebuild a server with a new image. This is advantageous in some scenarios and shoudl be supported by the OS::Nova::Server resource.


Gerrit topic: https://review.openstack.org/#q,topic:51966,n,z
Addressed by: https://review.openstack.org/51966
    Add rebuild to OS::Nova::Server

Some notes:

Rebuild 会有一段停机重启的时间，如果需要尽可能少的下线时间应该使用Replacement。Replacement在删除老的虚拟机前会先启动新的虚拟机。
- Rebuild is not desirable if you want minimal downtime for the server. The server will be shut down and unavailable during a rebuild. Replacement should have the new server up and running before deleting the old one, leading to less downtime (if any, if the addresses are propagated before deleting the old one). Mostly, rebuild is a cost savings so that you do not need to have two servers.

---

软件配置相关BP

---
## software deployment vm 镜像的构建过程，HOOK是如何安装的？
https://github.com/openstack/heat-templates/blob/master/hot/software-config/elements/README.rst
https://github.com/openstack/diskimage-builder


---

## /engine/service.py

class EngineService(service.Service):
    @request_context
    def create_software_deployment(self, cnxt, server_id, config_id,
                                   input_values, action, status,
                                   status_reason, stack_user_project_id):

        sd = db_api.software_deployment_create(cnxt, {
            'config_id': config_id,
            'server_id': server_id,
            'input_values': input_values,
            'tenant': cnxt.tenant_id,
            'stack_user_project_id': stack_user_project_id,
            'action': action,
            'status': status,
            'status_reason': status_reason})
        self._push_metadata_software_deployments(cnxt, server_id)
        return api.format_software_deployment(sd)

    def _push_metadata_software_deployments(self, cnxt, server_id):
        rs = db_api.resource_get_by_physical_resource_id(cnxt, server_id)
        if not rs:
            return
        deployments = self.metadata_software_deployments(cnxt, server_id)
        md = rs.rsrc_metadata or {}
        md['deployments'] = deployments
        rs.update_and_save({'rsrc_metadata': md})

        metadata_put_url = None
        for rd in rs.data:
            if rd.key == 'metadata_put_url':
                metadata_put_url = rd.value
                break
        if metadata_put_url:  # -> 默认情况下metadata_put_url为空，server 的属性 software_config_transport 为 'POLL_TEMP_URL' 即使用 swift 服务存放 metadata 时，才需要发送 rest 。
            json_md = jsonutils.dumps(md)
            requests.put(metadata_put_url, json_md)
class Server(stack_user.StackUser):

    PROPERTIES = (
        NAME, IMAGE, BLOCK_DEVICE_MAPPING, FLAVOR,
        FLAVOR_UPDATE_POLICY, IMAGE_UPDATE_POLICY, KEY_NAME,
        ADMIN_USER, AVAILABILITY_ZONE, SECURITY_GROUPS, NETWORKS,
        SCHEDULER_HINTS, METADATA, USER_DATA_FORMAT, USER_DATA,
        RESERVATION_ID, CONFIG_DRIVE, DISK_CONFIG, PERSONALITY,
        ADMIN_PASS, SOFTWARE_CONFIG_TRANSPORT
    ) = (
        'name', 'image', 'block_device_mapping', 'flavor',
        'flavor_update_policy', 'image_update_policy', 'key_name',
        'admin_user', 'availability_zone', 'security_groups', 'networks',
        'scheduler_hints', 'metadata', 'user_data_format', 'user_data',
        'reservation_id', 'config_drive', 'diskConfig', 'personality',
        'admin_pass', 'software_config_transport'
    )
    SOFTWARE_CONFIG_TRANSPORT: properties.Schema(
            properties.Schema.STRING,
            _('How the server should receive the metadata required for '
              'software configuration. POLL_SERVER_CFN will allow calls to '
              'the cfn API action DescribeStackResource authenticated with '
              'the provided keypair. POLL_SERVER_HEAT will allow calls to '
              'the Heat API resource-show using the provided keystone '
              'credentials. POLL_TEMP_URL will create and populate a '
              'Swift TempURL with metadata for polling.'),
            default=POLL_SERVER_CFN,
            constraints=[
                constraints.AllowedValues(_SOFTWARE_CONFIG_TRANSPORTS),
            ]
        ),
    _SOFTWARE_CONFIG_TRANSPORTS = (
        POLL_SERVER_CFN, POLL_SERVER_HEAT, POLL_TEMP_URL
    ) = (
        'POLL_SERVER_CFN', 'POLL_SERVER_HEAT', 'POLL_TEMP_URL'
    )
    def _populate_deployments_metadata(self, meta):
        meta['deployments'] = meta.get('deployments', [])
        if self.transport_poll_server_heat():
            meta['os-collect-config'] = {'heat': {
                'user_id': self._get_user_id(),
                'password': self.password,
                'auth_url': self.context.auth_url,
                'project_id': self.stack.stack_user_project_id,
                'stack_id': self.stack.identifier().stack_path(),
                'resource_name': self.name}
            }
        elif self.transport_poll_server_cfn():
            meta['os-collect-config'] = {'cfn': {
                'metadata_url': '%s/v1/' % cfg.CONF.heat_metadata_server_url,
                'access_key_id': self.access_key,
                'secret_access_key': self.secret_key,
                'stack_name': self.stack.name,
                'path': '%s.Metadata' % self.name}
            }
        elif self.transport_poll_temp_url():
            container = self.physical_resource_name()
            object_name = str(uuid.uuid4())

            self.client('swift').put_container(container)

            url = self.client_plugin('swift').get_temp_url(
                container, object_name, method='GET')
            put_url = self.client_plugin('swift').get_temp_url(
                container, object_name)
            self.data_set('metadata_put_url', put_url)
            self.data_set('metadata_object_name', object_name)

            meta['os-collect-config'] = {'request': {
                'metadata_url': url}
            }
            self.client('swift').put_object(
                container, object_name, jsonutils.dumps(meta))
        self.metadata_set(meta)

os-collect-config 如何被使用的？

---
## HOOK script 是如何处理的？

https://github.com/openstack/heat-templates/blob/master/hot/software-config/elements/README.rst
Software configuration hooks

This directory contains `diskimage-builder <https://github.com/openstack/diskimage-builder>`_
elements to build an image which contains the software configuration hook
required to use your preferred configuration method.

These elements depend on some elements found in the
`tripleo-image-elements <https://github.com/openstack/tripleo-image-elements>`_
repository. These elements will build an image which uses
`os-collect-config <https://github.com/openstack/os-collect-config>`_,
`os-refresh-config <https://github.com/openstack/os-refresh-config>`_, and
`os-apply-config <https://github.com/openstack/os-apply-config>`_ together to
invoke a hook with the supplied configuration data, and return any outputs back
to heat.

* tripleo-image-elements Disk image elements for deployment images of OpenStack
* os-collect-config Collect and cache metadata, run hooks on changes. 
* os-refresh-config Restart services and coordinate data migration on Heat config changes. 
* os-apply-config Apply configuration from cloud metadata.

下面这张图很清楚：
https://github.com/openstack/os-collect-config/blob/master/os-collect-config-and-friends.svg

---
software deployment 操作是在什么时候执行的？启动虚拟机的时候还是启动虚拟机前，heat template 中 resource 的依赖关系，除了显示的使用 depand on 外应该还有自己引用关系带来的隐式依赖。显示和隐式依赖模板解析，resource创建时是如何处理的。

nova 的 metadat 是否可以更新？更新后虚拟机会几时的获取到更新的 metadata 吗？


/engine/resources/server.py
    def handle_update(self, json_snippet, tmpl_diff, prop_diff):
        if 'Metadata' in tmpl_diff:
            self.metadata_set(tmpl_diff['Metadata'])

        checkers = []
        server = None

        if self.METADATA in prop_diff:  # 这里的 'metadata' 是 nova server 的属性，不是software deployment 带来的 metadat 更新。
            server = self.nova().servers.get(self.resource_id)
            self.client_plugin().meta_update(server,
                                             prop_diff[self.METADATA])

---
## 关于 scale up/down 的进一步说明 虚拟机可以通过 stack update 过程（模板中修改 flavor ）进行 resize，有没有可能通过 ceilometer 触发 flavor 调整待确定

/engine/resources/server.py
    def handle_update(self, json_snippet, tmpl_diff, prop_diff):
        if self.FLAVOR in prop_diff:

            flavor_update_policy = (
                prop_diff.get(self.FLAVOR_UPDATE_POLICY) or
                self.properties.get(self.FLAVOR_UPDATE_POLICY))

            if flavor_update_policy == 'REPLACE':
                raise resource.UpdateReplace(self.name)

            flavor = prop_diff[self.FLAVOR]
            flavor_id = self.client_plugin().get_flavor_id(flavor)
            if not server:
                server = self.nova().servers.get(self.resource_id)
            checker = scheduler.TaskRunner(self.client_plugin().resize,
                                           server, flavor, flavor_id)
            checkers.append(checker)


---

# Juno BP

## Plugpoint for stack lifecycle events

https://blueprints.launchpad.net/heat/+spec/stack-lifecycle-plugpoint
http://specs.openstack.org/openstack/heat-specs/specs/stack-lifecycle-plugpoint.html

A heat provider may have a need for custom code to examine stack requests prior to performing the operations to create or update a stack. Some applications may also need code to run after operations on a stack complete. The blueprint describes a mechanism whereby providers may easily add pre-operation calls from heat to their own code, which is called prior to performing the stack work, and post-operation calls which are made after a stack operation completes or fails.


## Make Heat software configuration action-aware
https://blueprints.launchpad.net/heat/+spec/action-aware-sw-config
http://specs.openstack.org/openstack/heat-specs/specs/action-aware-sw-config.html

With the current design, "software components" defined thru SoftwareConfig resources allow for only one config (e.g. one script) to be specified. Typically, however, a software component has a lifecycle that is hard to express in a single script. For example, software must be installed (created), there should be support for suspend/resume handling, and it should be possible to allow for deletion-logic. This is also in line with the general Heat resource lifecycle.

A proposal for an “lifecycle action aware” software config could look like:

 my_sw_config:
   type: OS::Heat::SoftwareConfig
   properties:
     configs:
       create: # the hook for software install
       suspend: # hook for suspend action
       resume: # hook for resume action
       delete: # hook for delete action
       my_own_stuff: # allow for any custom config hook

I.e. the SoftwareConfig resource would allow for defining several configurations for different lifecycle actions of the corresponding SoftwareDeployment at runtime. The handling will be done by an in-instance hook into os-collect-config. For Heat's default resource lifecycle actions (create, delete, suspend, resume) handling logic can be implemented in a generic hook. For any custom configurations ('my_own_stuff') users will have to provide their own hooks with the necessary logic.

---

{'OS::Nova::ServerGroup': ServerGroup}
"anti-affinity", "affinity"

---
ceilometer meters /heat/engine/resources/ceilometer/alarm.py

NOVA_METERS = ['instance', 'memory', 'memory.usage',
               'cpu', 'cpu_util', 'vcpus',
               'disk.read.requests', 'disk.read.requests.rate',
               'disk.write.requests', 'disk.write.requests.rate',
               'disk.read.bytes', 'disk.read.bytes.rate',
               'disk.write.bytes', 'disk.write.bytes.rate',
               'disk.device.read.requests', 'disk.device.read.requests.rate',
               'disk.device.write.requests', 'disk.device.write.requests.rate',
               'disk.device.read.bytes', 'disk.device.read.bytes.rate',
               'disk.device.write.bytes', 'disk.device.write.bytes.rate',
               'disk.root.size', 'disk.ephemeral.size',
               'network.incoming.bytes', 'network.incoming.bytes.rate',
               'network.outgoing.bytes', 'network.outgoing.bytes.rate',
               'network.incoming.packets', 'network.incoming.packets.rate',
               'network.outgoing.packets', 'network.outgoing.packets.rate']

