## [PYTHON WITH语句](http://squarey.me/language/python-with-statement.html)

### 一.with语句
在python 2.6中，with成为关键字。
类似于try-except-finally，with语句用于简化代码。
with常用使用场景是保证共享的资源的唯一分配，并在任务结束时释放。 如文件、线程资源、简单同步、数据库连接等等。

```py
    
    file = open("/tmp/foo.txt")
    try:
        data = file.read()
    finally:
        file.close()

```
```

	with open("/tmp/foo.txt") as file:
	   data = file.read()

```

with语句仅能工作于支持上下文管理协议（context management protocol）的对象。

### 二.原理
1.当with语句执行时，便执行上下文符号来获取一个上下文管理器。
上下文管理器提供一个上下文对象，通过调用__context()__方法实现。

2.一旦获得了上下文对象，调用它的__enter()__方法。它完成with语句块执行前的所有准备工作。

3.with语句块执行结束时，调用__exit__()方法。

### 参考：
* [Python核心编程]
[Understanding Python’s “with” statement](http://effbot.org/zone/python-with-statement.htm)
[Understanding Python’s “with” statement](http://sdqali.in/blog/2012/07/09/understanding-pythons-with/)