from ansible.plugins.callback import CallbackBase


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'notification'
    CALLBACK_NAME = 'test_callback'
    CALLBACK_NEEDS_WHITELIST = True

    def __init__(self):
        super(CallbackModule, self).__init__()
        self.play = None
        self.loader = None

    def v2_playbook_on_play_start(self, play):
        """Display Playbook and play start messages"""

        self.play = play
        self.loader = play.get_loader()
        return

    def v2_playbook_on_stats(self, stats):
        """Display info about playbook statistics"""

        hosts = sorted(stats.processed.keys())
        variable_manager = self.play.get_variable_manager()
        hostvars = variable_manager.get_vars(self.loader)['hostvars']
        cluster_name = hostvars['host1']['cluster_name']
         
        self._display.warning('cluster_name: %r' % cluster_name)
        self._display.display('cluster_name: %r' % cluster_name)
        self._display.error('cluster_name: %r' % cluster_name)


