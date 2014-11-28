#!/usr/bin/env python

class Demo(object):
    class_counter = 0
    def __init__(self):
        Demo.class_counter += 1
        print Demo.class_counter

if __name__ == '__main__':
    a = Demo()
    b = Demo()
    print id(a), id(b)
