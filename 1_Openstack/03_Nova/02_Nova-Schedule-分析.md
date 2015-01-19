http://specs.openstack.org/openstack/nova-specs/priorities/kilo-priorities.html
Scheduler
This paves the way to pulling out the scheduler allowing for faster scheduler development while reducing the scope of nova to help with nova’s growth challenges

Juno 相关修改，sch-lib group-api, vm-em -> 原因 cell 调度，还不成熟，不够合理；
将调动器从nova代码中剥离出来，以加快调动器的开发并减少nova本身关注的范围从而降低nova代码膨胀带来的调整。
kilo 版本后基本具备gantt合入条件，做了哪些准备（sh-lib，object化，DB依赖减少...）

---

## nova-conductor

Nova server 是如何开启 RPC Brocker（接收） 的？

.//nova/conductor/manager.py:93:        self.additional_endpoints.append(self.compute_task_mgr)
.//nova/manager.py:76:        self.additional_endpoints = []
.//nova/service.py:194:        endpoints.extend(self.manager.additional_endpoints)

## .//nova/conductor/manager.py
class ConductorManager(manager.Manager):
    """Mission: Conduct things.

    The methods in the base API for nova-conductor are various proxy operations
    performed on behalf of the nova-compute service running on compute nodes.
    Compute nodes are not allowed to directly access the database, so this set
    of methods allows them to get specific work done without locally accessing
    the database.

    The nova-conductor service also exposes an API in the 'compute_task'
    namespace.  See the ComputeTaskManager class for details.
    """
    def __init__(self, *args, **kwargs):
        self.compute_task_mgr = ComputeTaskManager()
        self.additional_endpoints.append(self.compute_task_mgr)

class ComputeTaskManager(base.Base):
    """Namespace for compute methods.

    This class presents an rpc API for nova-conductor under the 'compute_task'
    namespace.  The methods here are compute operations that are invoked
    by the API service.  These methods see the operation to completion, which
    may involve coordinating activities on multiple compute nodes.
    """

    target = messaging.Target(namespace='compute_task', version='1.9')

    def __init__(self):
        super(ComputeTaskManager, self).__init__()
        self.compute_rpcapi = compute_rpcapi.ComputeAPI()
        self.image_api = image.API()
        self.scheduler_client = scheduler_client.SchedulerClient()

    def migrate_server(self, context, instance, scheduler_hint, live, rebuild,
            flavor, block_migration, disk_over_commit, reservations=None):

    def build_instances(self, context, instances, image, filter_properties,
            admin_password, injected_files, requested_networks,
            security_groups, block_device_mapping=None, legacy_bdm=True):

    def unshelve_instance(self, context, instance):
 
    def rebuild_instance(self, context, instance, orig_image_ref, image_ref,
                         injected_files, new_pass, orig_sys_metadata,
                         bdms, recreate, on_shared_storage,
                         preserve_ephemeral=False, host=None):

## .//nova/service.py


from nova import rpc
class Service(service.Service):
    """Service object for binaries running on hosts.

    A service takes a manager and enables rpc by listening to queues based
    on topic. It also periodically runs tasks on the manager and reports
    it state to the database services table.
    """

    def __init__(self, host, binary, topic, manager, report_interval=None,
                 periodic_enable=None, periodic_fuzzy_delay=None,
                 periodic_interval_max=None, db_allowed=True,
                 *args, **kwargs):
        manager_class = importutils.import_class(self.manager_class_name)
        self.manager = manager_class(host=self.host, *args, **kwargs)

    def start(self):
        LOG.debug("Creating RPC server for service %s", self.topic)

        target = messaging.Target(topic=self.topic, server=self.host)

        endpoints = [
            self.manager,
            baserpc.BaseRPCAPI(self.manager.service_name, self.backdoor_port)
        ]
        endpoints.extend(self.manager.additional_endpoints)

        serializer = objects_base.NovaObjectSerializer()

        self.rpcserver = rpc.get_server(target, endpoints, serializer)
        self.rpcserver.start()

## nova/service.py
from oslo import messaging

def get_server(target, endpoints, serializer=None):
    assert TRANSPORT is not None
    serializer = RequestContextSerializer(serializer)
    return messaging.get_rpc_server(TRANSPORT,
                                    target,
                                    endpoints,
                                    executor='eventlet',
                                    serializer=serializer)

# oslo/messaging/rpc/server.py
def get_rpc_server(transport, target, endpoints,
                   executor='blocking', serializer=None):
    """Construct an RPC server.

    The executor parameter controls how incoming messages will be received and
    dispatched. By default, the most simple executor is used - the blocking
    executor.

    :param transport: the messaging transport
    :type transport: Transport
    :param target: the exchange, topic and server to listen on
    :type target: Target
    :param endpoints: a list of endpoint objects
    :type endpoints: list
    :param executor: name of a message executor - for example
                     'eventlet', 'blocking'
    :type executor: str
    :param serializer: an optional entity serializer
    :type serializer: Serializer
    """
    dispatcher = rpc_dispatcher.RPCDispatcher(target, endpoints, serializer)
    return msg_server.MessageHandlingServer(transport, dispatcher, executor)
## oslo/messaging/rpc/dispatcher.py
class RPCDispatcher(object):
    """A message dispatcher which understands RPC messages.

    A MessageHandlingServer is constructed by passing a callable dispatcher
    which is invoked with context and message dictionaries each time a message
    is received.

    RPCDispatcher is one such dispatcher which understands the format of RPC
    messages. The dispatcher looks at the namespace, version and method values
    in the message and matches those against a list of available endpoints.

    Endpoints may have a target attribute describing the namespace and version
    of the methods exposed by that object. All public methods on an endpoint
    object are remotely invokable by clients.
    """

    def __init__(self, target, endpoints, serializer):
        """Construct a rpc server dispatcher.

        :param target: the exchange, topic and server to listen on
        :type target: Target
        """

        self.endpoints = endpoints
        self.serializer = serializer or msg_serializer.NoOpSerializer()
        self._default_target = msg_target.Target()
        self._target = target

    def _do_dispatch(self, endpoint, method, ctxt, args):
        ctxt = self.serializer.deserialize_context(ctxt)
        new_args = dict()
        for argname, arg in six.iteritems(args):
            new_args[argname] = self.serializer.deserialize_entity(ctxt, arg)
        result = getattr(endpoint, method)(ctxt, **new_args)
        return self.serializer.serialize_entity(ctxt, result)

    @contextlib.contextmanager
    def __call__(self, incoming):
        incoming.acknowledge()
        yield lambda: self._dispatch_and_reply(incoming)

    def _dispatch_and_reply(self, incoming):
        try:
            incoming.reply(self._dispatch(incoming.ctxt,
                                          incoming.message))
        except e:


    def _dispatch(self, ctxt, message):
        """Dispatch an RPC message to the appropriate endpoint method.

        :param ctxt: the request context
        :type ctxt: dict
        :param message: the message payload
        :type message: dict
        :raises: NoSuchMethod, UnsupportedVersion
        """
        method = message.get('method')
        args = message.get('args', {})
        namespace = message.get('namespace')
        version = message.get('version', '1.0')

        found_compatible = False
        for endpoint in self.endpoints:
            target = getattr(endpoint, 'target', None)
            if not target:
                target = self._default_target

            if not (self._is_namespace(target, namespace) and
                    self._is_compatible(target, version)):
                continue

            if hasattr(endpoint, method):
                localcontext.set_local_context(ctxt)
                try:
                    return self._do_dispatch(endpoint, method, ctxt, args)
                finally:
                    localcontext.clear_local_context()

            found_compatible = True

        if found_compatible:
            raise NoSuchMethod(method)
        else:
            raise UnsupportedVersion(version)
