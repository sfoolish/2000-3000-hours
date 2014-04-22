#!/usr/bin/env python

def fibonacci():
	x, y = 0, 1
	while True:
		yield x
		x, y = y, x + y

def test_fib1():
	import itertools
	print list(itertools.islice(fibonacci(), 10))

def test_fib2():
	for i in fibonacci():
		if i > 100:
			break
		print i, 
	print ""

def test_fib3():
	print [i for i in fibonacci() if i < 100]


def peel(itertable, arg_cnt):
	iterator = iter(itertable)
	for i in xrange(arg_cnt):
		yield iterator.next()
	yield iterator

def test_peel1():
	args = xrange(10)
	a, b, c = peel(args, 2)
	print a, b, list(c)

def test_peel2():
	args = xrange(2)
	a, b, c = peel(args, 2)
	print a, b, list(c)

def test_peel3():
	try:
		args = xrange(1)
		a, b, c = peel(args, 2)
		print a, b, list(c)
	except ValueError, err:
		print err

if "__main__" == __name__:
	test_fib1()
	test_fib2()
	# test_fib3()  ??? go infinite why ???
	test_peel1()
	test_peel2()
	test_peel3()
