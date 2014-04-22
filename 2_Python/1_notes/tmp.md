---
## 语言基础

### [你真的会python嘛?](http://www.dongwm.com/archives/ni-zhen-de-hui-pythonma/)
写的很在理，好好梳理一下 python 的基础知识。

#### 你知道 python 怎么用嘛?
* 优缺点
* 适用场景，经典案例

在什么时候需要使用OOP？

#### 在什么时候使用类装饰器?

[Python Closures and Decorators (Pt. 1)](http://blaag.haard.se/Python-Closures-and-Decorators--Pt--1/)
[Python Closures and Decorators (Pt. 2)](http://blaag.haard.se/Python-Closures-and-Decorators--Pt--2/)
[Python 的闭包和装饰器](http://doc.42qu.com/python/python-closures-and-decorators.html)

decorator 与面向方面的编程（AOP aspect-oriented-program）

哪些是 pythonic 的？

http://stackoverflow.com/questions/13857/can-you-explain-closures-as-they-relate-to-python

whatsnew/2.4.rst

PEP 318: Decorators for Functions and Methods
=============================================

Python 2.2 extended Python's object model by adding static methods and class
methods, but it didn't extend Python's syntax to provide any new way of defining
static or class methods.  Instead, you had to write a :keyword:`def` statement
in the usual way, and pass the resulting method to a :func:`staticmethod` or
:func:`classmethod` function that would wrap up the function as a method of the
new type. Your code would look like this::

   class C:
      def meth (cls):
          ...

      meth = classmethod(meth)   # Rebind name to wrapped-up class method

If the method was very long, it would be easy to miss or forget the
:func:`classmethod` invocation after the function body.

The intention was always to add some syntax to make such definitions more
readable, but at the time of 2.2's release a good syntax was not obvious.  Today
a good syntax *still* isn't obvious but users are asking for easier access to
the feature; a new syntactic feature has been added to meet this need.

The new feature is called "function decorators".  The name comes from the idea
that :func:`classmethod`, :func:`staticmethod`, and friends are storing
additional information on a function object; they're *decorating* functions with
more details.

The notation borrows from Java and uses the ``'@'`` character as an indicator.
Using the new syntax, the example above would be written::

   class C:

      @classmethod
      def meth (cls):
          ...


The ``@classmethod`` is shorthand for the ``meth=classmethod(meth)`` assignment.
More generally, if you have the following::

   @A
   @B
   @C
   def f ():
       ...

It's equivalent to the following pre-decorator code::

   def f(): ...
   f = A(B(C(f)))

Decorators must come on the line before a function definition, one decorator per
line, and can't be on the same line as the def statement, meaning that ``@A def
f(): ...`` is illegal.  You can only decorate function definitions, either at
the module level or inside a class; you can't decorate class definitions.

A decorator is just a function that takes the function to be decorated as an
argument and returns either the same function or some new object.  The return
value of the decorator need not be callable (though it typically is), unless
further decorators will be applied to the result.  It's easy to write your own
decorators.  The following simple example just sets an attribute on the function
object::

   >>> def deco(func):
   ...    func.attr = 'decorated'
   ...    return func
   ...
   >>> @deco
   ... def f(): pass
   ...
   >>> f
   <function f at 0x402ef0d4>
   >>> f.attr
   'decorated'
   >>>

As a slightly more realistic example, the following decorator checks that the
supplied argument is an integer::

   def require_int (func):
       def wrapper (arg):
           assert isinstance(arg, int)
           return func(arg)

       return wrapper

   @require_int
   def p1 (arg):
       print arg

   @require_int
   def p2(arg):
       print arg*2

An example in :pep:`318` contains a fancier version of this idea that lets you
both specify the required type and check the returned type.

Decorator functions can take arguments.  If arguments are supplied, your
decorator function is called with only those arguments and must return a new
decorator function; this function must take a single function and return a
function, as previously described.  In other words, ``@A @B @C(args)`` becomes::

   def f(): ...
   _deco = C(args)
   f = A(B(_deco(f)))

Getting this right can be slightly brain-bending, but it's not too difficult.

A small related change makes the :attr:`func_name` attribute of functions
writable.  This attribute is used to display function names in tracebacks, so
decorators should change the name of any new function that's constructed and
returned.


.. seealso::

   :pep:`318` - Decorators for Functions, Methods and Classes
      Written  by Kevin D. Smith, Jim Jewett, and Skip Montanaro.  Several people
      wrote patches implementing function decorators, but the one that was actually
      checked in was patch #979728, written by Mark Russell.

   http://www.python.org/moin/PythonDecoratorLibrary
      This Wiki page contains several examples of decorators.


[Built-in Functions](Doc/library/function)

classmethod 与 staticmethod 的区别，适用场景是？

.. function:: classmethod(function)

   Return a class method for *function*.

   A class method receives the class as implicit first argument, just like an
   instance method receives the instance. To declare a class method, use this
   idiom::

      class C:
          @classmethod
          def f(cls, arg1, arg2, ...): ...

   The ``@classmethod`` form is a function :term:`decorator` -- see the description
   of function definitions in :ref:`function` for details.

   It can be called either on the class (such as ``C.f()``) or on an instance (such
   as ``C().f()``).  The instance is ignored except for its class. If a class
   method is called for a derived class, the derived class object is passed as the
   implied first argument.

   Class methods are different than C++ or Java static methods. If you want those,
   see :func:`staticmethod` in this section.

   For more information on class methods, consult the documentation on the standard
   type hierarchy in :ref:`types`.

   .. versionadded:: 2.2

   .. versionchanged:: 2.4
      Function decorator syntax added.

.. function:: staticmethod(function)

   Return a static method for *function*.

   A static method does not receive an implicit first argument. To declare a static
   method, use this idiom::

      class C:
          @staticmethod
          def f(arg1, arg2, ...): ...

   The ``@staticmethod`` form is a function :term:`decorator` -- see the
   description of function definitions in :ref:`function` for details.

   It can be called either on the class (such as ``C.f()``) or on an instance (such
   as ``C().f()``).  The instance is ignored except for its class.

   Static methods in Python are similar to those found in Java or C++. Also see
   :func:`classmethod` for a variant that is useful for creating alternate
   class constructors.

   For more information on static methods, consult the documentation on the
   standard type hierarchy in :ref:`types`.

   .. versionadded:: 2.2

   .. versionchanged:: 2.4
      Function decorator syntax added.



你用过元类嘛?
在什么时候用静态方法什么时候使用类方法?
你了解那些管理属性? call , init , __new__都是在什么时候被触发?__getattr__和__getattribute__应用有什么不同?
你知道标准库里面的多少个模块?你能在需要的时候知道这个功能其实标准库里面已经实现了?
什么时候用回调？
什么时候用signal？假如你会django你知道django的signal是什么?你了解orm嘛?
asyncore，contextlib， functools， collections， heapq，itertools， SocketServer， weakref，operator(知道3个就算)这些你会几个？
python的多态是什么?
在什么场景可以尝试python的设计模式中的XX(能想到2个场景就算)?
### 在什么时候可以使用Mixin？
[Mixin](http://en.wikipedia.org/wiki/Mixin) In object-oriented programming languages, a mixin is a class which contains a combination of methods from other classes. How such combination is done depends on language, but it is not by inheritance. If a combination contains all methods of combined classes it is equivalent to multiple inheritance.

[Using Mix-ins with Python](http://www.linuxjournal.com/node/4540/print)
[Mix-in技术介绍](http://wiki.woodpecker.org.cn/moin/IntroMixin)
[Mixin 扫盲班](http://blog.csdn.net/gzlaiyonghao/article/details/1656969)

e.g. tornado.auth.py

在什么时候可以使用python的闭包？
你曾经用过yield嘛？生成器和迭代器的区别和应用场景是什么?
在什么可以使用python的函数式编程?
__future__模块里面都有什么定义的用法?

---
## DOC
要好好看看官方文档。
### Doc/reference/datamodel.rst
class 的 `__init__, __new__, __del__` 等方法的作用是什么，会在什么时候被调用。

---
## tornado 源码阅读
* python 的一些典型处理方法；
    - (ioloop.py)try ... except 实现兼容性处理；
    - (iostream.py)经典的对象继承，重载关系 BaseIOStream -> IOStream -> SSLIOStream；
    - decorator 标准库提供的，自己实现的；

* 异步 IO 的实现机制；
    - iostream.py 要点：
        - callback 与 stack_context.wrap；
        - ioloop 驱动 callback ；

    - ioloop.py 要点：
        - global IOLoop instance 实现原理；

* 对 WebSocket 的支持；

* 异步调用的实现机制；
	- tornado.gen

### REF
* [Tornado源码分析之http服务器篇](http://kenby.iteye.com/blog/1159621)

---
## 函数式编程
* [Functional Programming with Python -- PyCon US 2013](http://pyvideo.org/video/1799/functional-programming-with-python)

---
## 调试方法
* pdb
