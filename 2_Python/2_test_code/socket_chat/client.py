#!/usr/bin/env python

import sys
import socket
import select
import os
import sys

class ChatClient(object):
    """ docstring
    """
    def __init__(self, host="localhost", port=8080):
        self.host = host
        self.port = port
        self.read_fd, self.write_fd = os.pipe()
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connect(self):
        try:
            self.socket.connect((self.host, self.port))
        except Exception, e:
            raise e

    def _user_input_handle(self):
        os.close(self.read_fd)
        self.socket.close()

        try:
            while True:
                mesg = raw_input("please input your worlds(input 'quit' for quit):")
                os.write(self.write_fd, mesg)
        except Exception, e:
            pass
        finally:
            os.close(self.write_fd)

    def _do_send_mesg_handle(self):
        mesg = os.read(self.read_fd, 1024)
        self.socket.sendall(mesg)

    def _do_recv_mesg_handle(self):
        data = self.socket.recv(1024)
        if 'quit' == data:
            self.socket.close()
            print 'we quit !'
            sys.exit() # TODO
        if len(data) == 0:
            self.socket.close()
            print 'server closed we quit !'
            sys.exit() # TODO
        print 'Received', repr(data)

    def _do_echo(self):
        os.close(self.write_fd)
        epoll = select.epoll()
        epoll.register(self.read_fd, select.EPOLLIN)
        epoll.register(self.socket.fileno(), select.EPOLLIN)

        try:
            while True:
                events = epoll.poll(1)
                for fileno, event in events:
                    if fileno == self.read_fd:
                        self._do_send_mesg_handle()
                    elif fileno == self.socket.fileno():
                        self._do_recv_mesg_handle()
        except Exception, e:
            print 'Exception recieved we quit !'
            raise e
        finally:
            os.close(self.read_fd)
            self.socket.close()

    def do_start_process(self):
        pid = os.fork()
        if pid == 0:
            self._user_input_handle()
        elif pid > 0:
            self._do_echo()
        else:
            raise

if __name__ == '__main__':
    HOST = 'localhost'
    PORT = 50007

    if (len(sys.argv) == 2):
        HOST = sys.argv[1]
    elif (len(sys.argv) == 3):
        HOST, PORT = sys.argv[1], int(sys.argv[2])

    client = ChatClient(HOST, PORT)
    client.connect()
    client.do_start_process()
