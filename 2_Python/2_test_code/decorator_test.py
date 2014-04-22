#!/usr/bin/env python

def func_without_args_decorator(func):
    def wrapper():
        print 'before function %s called', func.__name__
        func()
        print 'after function %s called', func.__name__
    return wrapper

@func_without_args_decorator
def decorated_func_without_args():
    print 'hello decorator'

print '-' * 80
decorated_func_without_args()

def func_with_args_decorator(func):
    def wrapper(*args, **kwargs):
        print 'before function %s called', func.__name__
        print 'args %r kwargs %r' % (args, kwargs)
        func(*args, **kwargs)
        print 'after function %s called', func.__name__
    return wrapper

@func_with_args_decorator
def decorated_func_with_args(*args, **kwargs):
        print 'hello decorator %r %r' % (args, kwargs)

print '-' * 80
decorated_func_with_args('abc', abc='abc')

def decorator_with_args(name='hello'):
    def func_without_args_decorator(func):
        def wrapper():
            print 'decorator %s before function %s called' % (name, func.__name__)
            func()
            print 'decorator %s after function %s called' % (name, func.__name__)
        return wrapper
    return func_without_args_decorator

@decorator_with_args()
def decorated_func_without_args1():
    print 'hello decorator'

print '-' * 80
decorated_func_without_args1()
