#!/usr/bin/env python
import threading
import random
import time

class MyThread(threading.Thread):
    def run(self):
        wait_time = random.randrange(1, 10)
        print "%s will wait %d seconds" % (self.name, wait_time)
        time.sleep(wait_time)
        print "%s finished!" % self.name

if __name__ == "__main__":
    print "main thread is waitting ..."

    for i in range(5):
        t = MyThread()
        t.setDaemon(True)
        t.start()

    print "main thread finished!"
