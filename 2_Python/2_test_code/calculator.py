#!/usr/bin/env python
import os

BASE='dir/'

def calc_file(file_name):
    try:
        f = open(file_name)
        res = 0
        for line in f.readlines():
            for data in line.split():
                res += int(data)
        f.close()
        return res
    except:
        print 'error'
        raise

def calc_files():
    files = os.popen('ls ' + BASE).read()
    for name in files.split():
        name = BASE + name
        print name + '\t'*2 + str(calc_file(name))

calc_files()
