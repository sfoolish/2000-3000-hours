#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
from bs4 import BeautifulSoup
import Queue, sys
from threading import Thread

def get_tag_up_num(tag):
    return tag.find('li', class_='up').text.strip()

def get_tag_title(tag):
    return tag.find('div', class_='content')['title']

def get_tag_content(tag):
    return tag.find('div', class_='content').text.strip()

def get_tag_img_url(tag):
    try:
        return tag.find('div', class_='thumb').find('img')['src']
    except Exception, e:
        return None

def get_page_content_blocks():
    results = []
    for tag in soup.find_all('div', class_='block untagged mb15 bs2'):
        results.append({'up' : get_tag_up_num(tag)
        , 'title' : get_tag_title(tag)
        , 'content' : get_tag_content(tag)
        , 'img_url' : get_tag_img_url(tag)})
    return results

def get_page_num():
    pagebar = soup.find('div', class_='pagebar')
    a = pagebar.find_all('a')
    return a[-2].text

def create_url(y, m, d, page):
    URL = 'http://www.qiushibaike.com/history/%d/%d/%d/page/%d'
    return URL % (y, m, d, page)

class Worker(Thread):
    worker_count = 0

    def __init__(self, workQueue, resultQueue, timeout = 0, **kwds):
        Thread.__init__(self, **kwds)
        self.id = Worker.worker_count
        Worker.worker_count += 1
        self.setDaemon(True)
        self.workQueue = workQueue
        self.resultQueue = resultQueue
        self.timeout = timeout
        self.start()

    def run(self):
        while True:
            try:
                callable, args, kwds = self.workQueue.get(timeout=self.timeout)
                res = callable(*args, **kwds)
                print "worker[%2d]: %s" % (self.id, str(res))
                self.resultQueue.put(res)
            except Queue.Empty:
                break
            except :
                print 'worker[%2d]' % self.id, sys.exc_info()[:2]
                  
class WorkerManager:
    def __init__(self, num_of_workers = 10, timeout = 1):
        self.workQueue = Queue.Queue()
        self.resultQueue = Queue.Queue()
        self.workers = []
        self.timeout = timeout
        self._recruit_threads(num_of_workers)

    def _recruit_threads(self, num_of_workers):
        for i in range(num_of_workers):
            worker = Worker(self.workQueue, self.resultQueue, self.timeout)
            self.workers.append(worker)

    def wait_for_complete(self):
        while len(self.workers):
            worker = self.workers.pop()
            worker.join()
            if worker.isAlive() and not self.workQueue.empty():
                self.workers.append(worker)

    def add_job(self, callable, *args, **kwds):
        self.workQueue.put((callable, args, kwds))

    def get_result(self, *args, **kwds):
        return self.resultQueue.get(*args, **kwds)

def page_crawling_job(id, sleep = 0.001):
    try:
        r = requests.get(create_url(2013, 9, 14, id))
        soup = BeautifulSoup(r.text)
        for res in get_page_content_blocks():
            print 80 * '-'
            for key, value in res.iteritems() :
                print key, ' : ', value
    except:
        print '[%4d]' % id, sys.exc_info()[:2]
    return id

def crawling_test(num):
    print 'start crawling'

    manager = WorkerManager(10)
    for i in range(1, num + 1):
        manager.add_job(page_crawling_job, i, i * 0.03)
    manager.wait_for_complete()
    
    print 'end crawling'

if __name__ == '__main__':

    r = requests.get(create_url(2013, 9, 14, 1))
    soup = BeautifulSoup(r.text)
    num = int(get_page_num())

    crawling_test(num)

