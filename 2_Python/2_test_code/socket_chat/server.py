#!/usr/bin/env python

import socket
import select

class ChatServer(object):
    """ docstring
    """
    def __init__(self, host='', port=8080):
        self.host = host
        self.port = port
        self.connections = {}
        self.requests    = {}
        self.responses   = {}
        self.epoll = select.epoll()
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    def bind(self):
        self.socket.bind((self.host, self.port))
        self.socket.listen(1)
        self.socket.setblocking(0)

    def _do_accept_handle(self, fileno = 0, event = 0):
        connection, address = self.socket.accept()
        connection.setblocking(0)
        self.epoll.register(connection.fileno(), select.EPOLLIN)
        self.connections[connection.fileno()] = connection
        self.requests[connection.fileno()] = b''

    def _do_mesg_handle(self, fileno = 0, event = 0):
        self.requests[fileno] += self.connections[fileno].recv(1024)

        if (len(self.requests[fileno]) == 0) or ('quit' == self.requests[fileno]):
            self.epoll.modify(fileno, select.EPOLLOUT)
            self.connections[fileno].send(self.requests[fileno])
            self.requests[fileno] = '%d is quit' % fileno

        for fno, connection in self.connections.iteritems():
            if fno != fileno:
                connection.send(self.requests[fileno])

        self.requests[fileno] = b''

    def do_echo(self):
        self.epoll.register(self.socket.fileno(), select.EPOLLIN)

        try:
            while True:
                events = self.epoll.poll(1)
                for fileno, event in events:
                    if fileno == self.socket.fileno():
                        self._do_accept_handle()
                    elif event & select.EPOLLIN:
                        self._do_mesg_handle(fileno, event)
                    elif event & select.EPOLLOUT:
                        self.epoll.modify(fileno, 0)
                        self.connections[fileno].shutdown(socket.SHUT_RDWR)
                    elif event & select.EPOLLHUP:
                        print 'file %d close' % fileno
                        self.epoll.unregister(fileno)
                        self.connections[fileno].close()
                        del self.connections[fileno]
        finally:
            self.epoll.unregister(self.socket.fileno())
            self.epoll.close()
            self.socket.close()

if __name__ == '__main__':
    HOST = ''
    PORT = 50007
    server = ChatServer(HOST, PORT)
    server.bind()
    server.do_echo()

