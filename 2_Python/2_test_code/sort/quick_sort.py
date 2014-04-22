#!/usr/bin/env python

def data_compare(a, b):
    if (a > b):
        return 1
    elif (a < b):
        return -1
    else:
        return 0

def quick_sort(a, func):
    l = len(a) 
    if l == 0:
        return a
    if l == 1:
        return a
    
    s = a[0]
    min = []
    max = []
    s_count = 1
    for i in xrange(1, l):
        if func(a[i], s) < 0:
            min.append(a[i])
        elif func(a[i], s) > 0:
            max.append(a[i])
        else:
            s_count += 1

    return quick_sort(min, func) + [s for i in xrange(s_count)] + quick_sort(max, func)

def list_compare(a, b):
    len_a = len(a)
    len_b = len(b)

    if len_a != len_b:
        return 1
    for i in xrange(len_a):
        if a[i] != b[i]:
            return 1

    return 0

if __name__ == '__main__':
    test = [2, 7, 4, 55, 33, 22, 45, 12, 34, 99, 2, 4, 4, 44, 66, 33, 7]
    res_0 = [2, 2, 4, 4, 4, 7, 7, 12, 22, 33, 33, 34, 44, 45, 55, 66, 99]
    res = quick_sort(test, data_compare)

    assert list_compare(res, res_0) == 0

