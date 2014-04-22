#!/usr/bin/env python

def closure_counter():
    def counter():
        counter.count += 1
        return counter.count
    counter.count = 0
    return counter

c1 = closure_counter()
c2 = closure_counter()
print (c1(), c1(), c2(), c2())