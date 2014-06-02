
## TODO

1. Neutron 单元测试的使用及其实现框架； --> python UT


stevedore.driver

---

## PluginRpcDispatcher

l3_router_plugin.py

from neutron.common import rpc as q_rpc

class L3RouterPluginRpcCallbacks(l3_rpc_base.L3RpcCallbackMixin):

    RPC_API_VERSION = '1.1'

    def create_rpc_dispatcher(self):
        """Get the rpc dispatcher for this manager.

        If a manager would like to set an rpc API version, or support more than
        one class as the target of rpc messages, override this method.
        """
        return q_rpc.PluginRpcDispatcher([self])

        self.router_scheduler = importutils.import_object(
            cfg.CONF.router_scheduler_driver)

    def setup_rpc(self):
        # RPC support
        self.topic = topics.L3PLUGIN
        self.conn = rpc.create_connection(new=True)
        self.agent_notifiers.update(
            {q_const.AGENT_TYPE_L3: l3_rpc_agent_api.L3AgentNotify})
        self.callbacks = L3RouterPluginRpcCallbacks()
        self.dispatcher = self.callbacks.create_rpc_dispatcher()
        self.conn.create_consumer(self.topic, self.dispatcher,
                                  fanout=False)
        self.conn.consume_in_thread()

