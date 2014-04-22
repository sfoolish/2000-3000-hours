---
# python 协程

python 协程是个好东西，抽空好好研究一下。

## REF
* [libtask](https://github.com/jamwt/libtask)
* [python协程及应用（一）：简介](http://www.cnblogs.com/chgaowei/archive/2012/06/21/2557175.html)
* [简谈coroutine](http://bookjovi.iteye.com/blog/1337512)
* [Python 协程：协程才是未来 / 被线程替代 / 推与拉](http://simple-is-better.com/news/363)
* [pycon_2009_coroutines](http://www.dabeaz.com/coroutines/Coroutines.pdf)
* [PEP 342 -- Coroutines via Enhanced Generators](http://www.python.org/dev/peps/pep-0342/)
* [协程_wiki_zh](https://zh.wikipedia.org/wiki/%E5%8D%8F%E7%A8%8B)
* [python与协程(1/3):生成器与协程](http://blog.csdn.net/lbaby/article/details/7234453)
* [python+协程 cnskypc ](http://www.cnskypc.com/python+%E5%8D%8F%E7%A8%8B.jsp)

---
# Python language basics
* [Python: Common Newbie Mistakes, Part 1](http://blog.amir.rachum.com/post/54770419679/python-common-newbie-mistakes-part-1)
* [Python: Common Newbie Mistakes, Part 2](http://blog.amir.rachum.com/post/55024295793/python-common-newbie-mistakes-part-2)
* [Python 新手常犯错误（第一部分）](http://blog.jobbole.com/42706/)
* [What else is there in Python?](http://blog.amir.rachum.com/post/27860231695/what-else-is-there-in-python)

## python-guide
    $ mkdir python-guide-git && cd python-guide-git
    $ git clon https://github.com/kennethreitz/python-guide.git .
    $ sudo apt-get install python-sphinx
    $ make                        ## 生成的文档在 doc/_build/ 下。
[python-guide](http://docs.python-guide.org), python best practices guidebook, written for Humans.

## ipython 使用
IPython: Productive Interactive Computing.IPython provides a rich toolkit to help you make the most out of using Python interactively. 
ipython 是 python 交互式 shell, 它支持代码自动补全，支持高亮，支持 shell 命令，使用起来非常的顺手，方便。

### Magic function
    %pdoc    Print the docstring for an object.

### REF
* [IPython manual](http://ipython.org/documentation.html)

## [Learn Python The Hard Way, 3rd Edition](http://learnpythonthehardway.org/book/)
What is the difference between %r and %s?

    Use the %r for debugging, since it displays the "raw" data of the variable, but the others are used for displaying to users.

Why does %r sometimes print things with single-quotes when I wrote them with double-quotes.

    Python is going to print the strings in the most efficient way it can, not replicate exactly the way you wrote them. This perfectly fine since %r is used for debugging and inspection, so it's not necessary that it be pretty.

What's the difference between input() and raw_input()?

    The input() function will try to convert things you enter as if they were Python code, but it has security problems so you should avoid it.

When my strings print out there's a u in front of them, as in u'35'.

    That's how Python tells you that the string is unicode. Use a %s format instead and you'll see it printed like normal.

Why are there empty lines between the lines in the file?

    The readline() function returns the \n that's in the file at the end of that line. This means that print's \n is being added to the one already returned by readline(). To change this behavior simply add a , (comma) at the end of print so that it doesn't print its own \n.

How does readline() know where each line is?

    Inside readline() is code that scans each byte of the file until it finds a \n character, then stops reading the file to return what it found so far. The file f is responsible for maintaining the current position in the file after each readline() call, so that it will keep reading each line.

## 漂亮的打印出 JSON
    import json
    
    data = {"status" : "OK", "count" : 2, "results" : [{"age" : 27, "name" : "Oz"}]}
    print(json.dumps(data, indent = 2))
    ```
        {
          "status": "OK", 
          "count": 2, 
          "results": [
            {
              "age": 27, 
              "name": "Oz"
            }
          ]
        }
    ```

### REF
* [Python高效编程技巧](http://python.42qu.com/11158039)

## python 中文使用
直接上代码：

    #!/usr/bin/python
    # -*- coding: utf-8 -*-
    
    s='测试'
    print s
    print s.decode('utf-8').encode('gbk')
    
    path = './文件.txt'
    spath = unicode(path, 'utf-8')
    f = open(spath, 'r')
    print f.read()
[PEP 0263 -- Defining Python Source Code Encodings](www.python.org/dev/peps/pep-0263)

## Convert char string to hex in python
    In [1]: 'hello'.encode('hex')
    Out[1]: '68656c6c6f'
    
    In [2]: '68656c6c6f'.decode('hex')
    Out[2]: 'hello'

## range 和 xrange 之间的差异

### Docstring 显示两者的差异
    In [6]: %pdoc range 
    Class Docstring:
        range([start,] stop[, step]) -> list of integers
        
        Return a list containing an arithmetic progression of integers.
        range(i, j) returns [i, i+1, i+2, ..., j-1]; start (!) defaults to 0.
        When step is given, it specifies the increment (or decrement).
        For example, range(4) returns [0, 1, 2, 3].  The end point is omitted!
        These are exactly the valid indices for a list of 4 elements.
    Calling Docstring:
        x.__call__(...) <==> x(...)
    
    In [7]: %pdoc xrange
    Class Docstring:
        xrange([start,] stop[, step]) -> xrange object
        
        Like range(), but instead of returning a list, returns an object that
        generates the numbers in the range on demand.  ** For looping, this is 
        slightly faster than range() and more memory efficient. **
    Constructor Docstring:
        x.__init__(...) initializes x; see help(type(x)) for signature

### [What is the difference between range and xrange?](http://stackoverflow.com/questions/94935/what-is-the-difference-between-range-and-xrange)
range creates a list, so if you do range(1, 10000000) it creates a list in memory with 10000000 elements. xrange is a generator, so it evaluates lazily.

This is true, but in Python 3, range will be replaced with xrange(). If you need to actually generate the list, you will need to do: `list(range(1,100))`

### python 2.7.3 test
    (env)$ python -m timeit 'for i in range(1000000):' ' pass'  
    10 loops, best of 3: 81.5 msec per loop
    (env)$ python -m timeit 'for i in xrange(1000000):' ' pass'
    10 loops, best of 3: 53 msec per loop

## [Understanding Python decorators](http://stackoverflow.com/questions/739654/understanding-python-decorators)
Decorators are wrappers which means that they let you execute code before and after the function they decorate without the need to modify the function itself.
    
    def makebold(fn):
        def wrapped():
            return "<b>" + fn() + "</b>"
        return wrapped
    
    def makeitalic(fn):
        def wrapped():
            return "<i>" + fn() + "</i>"
        return wrapped
    
    @makebold
    @makeitalic
    def hello():
        return "hello world"
    
    print hello() ## returns <b><i>hello world</i></b>

## [A guide to Python packaging](http://www.ibm.com/developerworks/opensource/library/os-pythonpackaging/index.html)

## Python 谈
* [“Python性能优化”讲稿分享](http://blog.csdn.net/lanphaday/article/details/2239445)
* [虚拟座谈会：PyCon嘉宾谈Python](http://www.infoq.com/cn/articles/virtual-panel-pycon)

## python 多线程
* [使用 Python 进行线程编程](http://www.ibm.com/developerworks/cn/aix/library/au-threadingpython/) urllib2 + queue + treading + BeautifulSoup
* [python线程池](http://www.the5fire.net/python-thread-pool.html)

## MAC OSX genvent install
遇到如下错误`gevent/libevent.h:9:19: error: event.h: No such file or directory`。

    $ sudo port install libevent
    $ sudo CFLAGS="-I /opt/local/include -L /opt/local/lib" pip install gevent
### REF
[How can I install the Python library 'gevent' on Mac OS X Lion](stackoverflow.com/questions/7630388/how-can-i-install-the-python-library-gevent-on-mac-os-x-lion)

## python 函数式编程
* [Fn.py：享受Python中的函数式编程](http://www.infoq.com/cn/articles/fn.py-functional-programming-python)
* [Functional programming with Python](http://kachayev.github.com/talks/uapycon2012/index.html#/)
* [kachayev / fn.py github](https://github.com/kachayev/fn.py)
* [Charming Python: Functional programming in Python, Part 1](http://www.ibm.com/developerworks/linux/library/l-prog/index.html)
* [Charming Python: Functional programming in Python, Part 2](http://www.ibm.com/developerworks/linux/library/l-prog2/index.html)
* [Charming Python: Functional programming in Python, Part 3](http://www.ibm.com/developerworks/linux/library/l-prog3/index.html)

## Python 代码规范
* [PEP8](http://www.python.org/dev/peps/pep-0008/)
* [Google Python Style Guide](http://google-styleguide.googlecode.com/svn/trunk/pyguide.html)
  - Function and Method Decorators   ??
  - Access Control                   ??

### [使用pep8 vim插件规范Python代码](http://blog.lzhaohao.info/archive/correct-python-source-style-using-pep8-vim-plugin/)
    $ sudo pip install pep8

    $ mkdr -p ~/.vim/ftplugin/python/
    $ cp [pep8.vim](http://www.vim.org/scripts/script.php?script_id=2914)  ~/.vim/ftplugin/python/
    ## or
    $ git clone git://github.com/sfoolish/vimrc.git ~/.vim_runtime
    $ sh ~/.vim_runtime/install_awesome_vimrc.sh


---
# Python 开发环境
## [Python-2.7.3](http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2)源码编译
    $ wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
    $ tar xvf Python-2.7.3.tar.bz2 
    $ cd Python-2.7.3
    $ ./configure --prefix=/Users/apple/APP_PRJ/d_python/3_Python-2.7/install
    $ make -j4
    $ make install
    $ export PATH=/Users/apple/APP_PRJ/d_python/3_Python-2.7/install/bin:$PATH
    $ python
    ```
        Python 2.7.3 (default, Jan  3 2013, 16:15:14) 
        [GCC 4.2.1 (Apple Inc. build 5666) (dot 3)] on darwin
        Type "help", "copyright", "credits" or "license" for more information.
        >>> quit()
    ```

## [EasyInstall](http://en.wikipedia.org/wiki/EasyInstall)安装
    $ wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea
    $ sh setuptools-0.6c11-py2.7.egg --help
    $ sh setuptools-0.6c11-py2.7.egg --prefix=/Users/apple/APP_PRJ/d_python/3_Python-2.7/install/

    ## 上面几步后 easy_install 无法正常使用
    $ wget http://python-distribute.org/distribute_setup.py
    $ python distribute_setup.py

### [pypi setuptools](http://pypi.python.org/pypi/setuptools)

## [Pip](http://en.wikipedia.org/wiki/Pip_%28Python%29)安装
    $ easy_install pip

### pip 通过代理下载软件包
    $ sudo pip --proxy=127.0.0.1:8087 install -r requirements.txt

## virtualenv

### virtualenv 安装

#### 通过 easy_install 安装
    $ easy_install virtualenv

#### 通过 pip 安装
    $ pip install virtualenv

#### 直接使用源码

    $ wget http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.8.4.tar.gz
    $ tar xvf virtualenv-1.8.4.tar.gz
    $ sudo python virtualenv-1.8.4/virtualenv.py ENV  # 创建虚拟环境

### virtualenv 使用
    $ sudo virtualenv ENV                             # pip 安装的，直接使用 virtualenv 命令
    $ source ENV/bin/activate                         # 激活虚拟环境
    $ deactivate                                      # 退出虚拟环境

    $ pip freeze > requirements.txt                   # 导出当前环境下的所有第三方库
    $ pip install -r requirements.txt                 # 安装所有文件内的第三方库

### virtualenv 的作用
VirtualEnv 用于在一台机器上创建多个独立的python运行环境。

使用 VirtualEnv 的理由：

* 隔离项目之间的第三方包依赖；
* 为部署应用提供方便，把开发环境的虚拟环境打包到生产环境即可；
* 解决库之间的版本依赖，比如同一系统上不同应用依赖同一个库的不同版本；
* 解决权限限制，比如你没有root权限；
* 尝试新的工具，而不用担心污染系统环境。

### virtualenv 的注意事项
使用virtualenv安装的Python环境都是相同版本的，如果你想安装不同版本，可以考虑使用其他应用，比如：[pythonbrew](https://github.com/utahta/pythonbrew)，[pyenv](https://github.com/utahta/pythonbrew)，[pythonz](https://github.com/saghul/pythonz)等等。

### REF
* [virtualenv: python的沙盒环境](http://iamsmallka.blog.163.com/blog/static/72703637201151994232351/)
* [学习搭建Python环境](http://huoding.com/2013/07/23/270)

---
# Google App Engine
* [GAE SDK Python](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_Python)
* [在GAE(Google App Engine)上搭建python2.7的web.py程序](http://blog.csdn.net/five3/article/details/7848748)

## 基于 Google App Engine 的 doudou 网
[创建 GAE APP](https://appengine.google.com/): APP ID doudou-sfoolish

本地测试：

    $ dev_appserver.py doudou/
代码部署：
    
    $ appcfg.py update doudou/
上传失败的时候，可以通过 rollback 进行恢复。

    $ appcfg.py help rollback
    $ appcfg.py rollback doudou
部署成功后就能访问[doudou](http://doudou-sfoolish.appspot.com/)

[doudou 源码](https://github.com/sfoolish/doudou)

---
# Tornado
## ubuntu 12.04 下测试tornado
    $ mkdir -p 2_tornado/1_tornado_git
    $ cd 2_tornado/1_tornado_git
    $ git clone https://github.com/facebook/tornado.git .
    $ export PYTHONPATH=$PYTHONPATH:/home/sfoolish/share/2_tornado/1_tornado_git
    $ cat hello_tornado.py
        >    import tornado.ioloop
        >    import tornado.web
        >
        >    class MainHandler(tornado.web.RequestHandler):
        >        def get(self):
        >            self.write("Hello, world !")
        >       
        >    application = tornado.web.Application([
        >        (r"/", MainHandler),
        >    ])
        > 
        >    if __name__ == "__main__":
        >        application.listen(8888)
        >        tornado.ioloop.IOLoop.instance().start()

    $ python hello_tornado.py

### REF
* [Simple example of a Tornado app in production](https://github.com/bdarnell/tornado-production-skeleton)
* [Tornado + Supervisor 在生产环境下的部署方法](https://idndx.com/2011/10/18/ways-to-deploy-tornado-under-production-environment-using-supervisor/)
* [有没有什么很好的 Tornado 的教材或者开源项目可以做参考的？](http://www.zhihu.com/question/19707966/answer/12731684)
* [Tornado：基于Python的非阻塞式实时Web服务器](http://breakaway.me/tornado.html)
    一个用Python写的相对简单的、可扩展、非阻塞的Web服务器架构，以处理上万的同时的连接口，让实时的Web服务通畅起来。跟现在一些用Python写的Web架构相似，比如Django，但更注重速度，能够处理海量的同时发生的流量。
*[tornado](http://www.tornadoweb.org/)
* [tornado cn](http://www.tornadoweb.cn/)
    Tornado is an open source version of the scalable, non-blocking web server and tools that power FriendFeed.
* [douban Tornado](http://www.douban.com/group/tornadoweb/)
* [FriendFeed](http://zh.wikipedia.org/zh-cn/FriendFeed)
    2009年8月10日，官方博客宣布其接受Facebook收购请求，正式成为Facebook的一部分。

---
## tornado 源码阅读
### 难点，python 高阶技术

---
## [How do I start a session in a Python web application?](http://stackoverflow.com/questions/1185406/how-do-i-start-a-session-in-a-python-web-application/1185437#1185437)
[Wikipedia](http://en.wikipedia.org/wiki/Session_cookie) is always a good place to start. Bottom line: session data gets stored somewhere on the server and indexed by a unique identifier (hash of some sort). This identifier gets passed back and forth between the client and server, usually as a cookie or as part of the query string (the URL). For security's sake, you'll want to use an SSL connection or validate the session ID with some other piece of data (e.g. IP address). By default PHP stores sessions as files, but on a shared server that could pose a security risk, so you might want to override the session engine so you store sessions in a database. Python web frameworks have similar functionality.

[Beaker](http://beaker.groovie.org/) is a library for caching and sessions for use with web applications and stand-alone Python scripts and applications. It comes with WSGI middleware for easy drop-in use with WSGI based web applications, and caching decorators for ease of use with any Python based application.

---
## uwsgi + nginx/tengine + web.py

### uwsgi python 安装
    $ apt-get install uwsgi-plugin-python

### [nginx/tengine 安装][ref]
    * [tengine ubuntu12.04 编译运行]:https://github.com/sfoolish/000-1000-hours/blob/master/4_note/tengine_learning.md#tengine-ubuntu1204-
    * 配置文件修改
        $ diff nginx.conf nginx.conf.default 
        ```
            44,45c44,45
            <             include uwsgi_params;
            <             uwsgi_pass 127.0.0.1:8080;
            ---
            >             root   html;
            >             index  index.html index.htm;
        ```
    * 运行 nginx

### 编写运行测试程序
    $ vim myweb.py
    $ cat myweb.py
    ```
        #!/usr/bin/env python
        
        import os, web, sys
        
        sys.path.append(os.path.dirname(__file__))
        
        urls=(
            r'/', 'Home'
            )
        
        class Home(object):
            def GET(self):
                return 'hello world!'
        
        app = web.application(urls, globals())
        application = app.wsgifunc()
    ```
    ## -H|--venv <path>  set python home/virtualenv
    $ uwsgi_python -H /root/prj/python/wiki_0.3/wiki_virt/ -s 127.0.0.1:8080 myweb.py 
    $ curl 127.0.0.1:8000
    ```
        hello world!
    ```

### REF
* [uwsgi+Nginx+web.py的搭建](http://www.yucoat.com/linux_opensource/uwsgi_nginx_web-py.html)
* [uWSGI](http://flask.pocoo.org/docs/deploying/uwsgi/)
* [Quickstart for python/WSGI applications](http://uwsgi-docs.readthedocs.org/en/latest/WSGIquickstart.html)
* [用uWSGI替代fastcgi部署django应用](http://ichuan.net/post/6/using-uwsgi-instead-of-fastcgi-for-django-app/)
* [uWSGI参考资料（1.0版本的配置选项列表）](http://disong.blogspot.com.au/2012/06/uwsgi.html)

## run [onlinestore-multi](https://github.com/nopri/onlinestore-multi)

### clone onlinestore-multi source code
    $ git clone https://github.com/nopri/onlinestore-multi.git
### mysql config
    $ mysql -u root -p
    ```
        Enter password: 
    ```
    mysql> create database onlinestore;
    ```
        Query OK, 1 row affected (0.03 sec)
    ```
    mysql> grant all privileges on onlinestore.* to onlinestore@localhost identified by 'onlinestore';
    ```
        Query OK, 0 rows affected (0.15 sec)
    ```
    mysql> flush privileges;
    ```
        Query OK, 0 rows affected (0.03 sec)
    ```
    mysql> quit;
    ```
        Bye
    ```
    $ mysql -D onlinestore -u onlinestore  -p < ./onlinestore-multi/db.sql
    ```
        Enter password:
    ```

### nginx add static file config
    $ cp -a onlinestore-multi/static html/
  
    +         location /static/ {
    +             root html;
    +             if (-f $request_filename) {
    +                 rewrite ^/static/(.*)$ /static/$1 break;
    +             }
    +         }
    +
              location / {
                  include uwsgi_params;
                  uwsgi_pass 127.0.0.1:8080;
              }

### run wsgi app
    $ cd onlinestore-multi/
    $ cp config.ini.dist config.ini
    $ vim config.ini
    $ diff config.ini config.ini.dist 
    ```
        6c6
        < pass = onlinestore
        ---
        > pass = 
    ```
    $ pip install pyyaml
    $ pip install PIL
    $ git diff -b
    ```
        diff --git a/app.py b/app.py
        index f14aebb..72f9f0f 100644
        --- a/app.py
        +++ b/app.py
        @@ -160,7 +160,7 @@ wapp = web.application(URLS, globals())
         
         def cget(section, option, default='', strip=True):
             c = ConfigParser.ConfigParser()
        -    c.read(CURDIR + PS + CONFIG_FILE_DEFAULT)
        +    c.read('./config.ini')
             try:
                 ret = c.get(section, option)
             except:
        @@ -243,7 +243,7 @@ def pget(option, default='', strip=True, callback=None):
         VERSION = '0.97'
         NAME = 'onlinestore-multi'
         PRECISION = 2
        -TEMPLATE_DIR = CURDIR + PS + 'template'
        +TEMPLATE_DIR = './template'
         DOC_ADMIN = CURDIR + PS + 'README.txt'
         DOMAIN = ''
         BASEURL_DEFAULT = '/store'
    ```
    $ uwsgi_python -H /root/prj/python/wiki_0.3/wiki_virt/ -s 127.0.0.1:8080 app.py

### REF
* [onlinestore-multi README](https://github.com/nopri/onlinestore-multi/blob/master/README.txt)
* [uwsgi nginx python](https://github.com/sfoolish/000-1000-hours/blob/master/4_note/python_learning.md#uwsgi--nginxtengine--webpy)

---
# django

## django install
    $ mkdir django
    $ cd django
    $ virtualenv --distribute venv
    $ source venv/bin/activate
    $ pip install django
    $ python -c "import django; print(django.get_version())"
    ```
        1.5.1
    ```

---
## june test

    $ git clone git://github.com/lepture/june.git
    $ cd june/
    $ virtualenv --distribute venv
    $ source venv/bin/activate
    $ sudo apt-get install libevent-dev 
    $ pip install -r conf/reqs-dev.txt

### REF
* [june/README.rst](https://github.com/lepture/june/blob/master/README.rst)
* [distribute pip-virtualenv install issue](https://bitbucket.org/tarek/distribute/issue/91/install-glitch-when-using-pip-virtualenv)

---
# 网络爬虫
## REF
* [用python爬虫抓站的一些技巧总结](http://obmem.info/?p=476)
* [使用python爬虫抓站的一些技巧总结：进阶篇](http://obmem.info/?p=753)
* [使用python/casperjs编写终极爬虫-客户端App的抓取](http://obmem.info/?p=848)
* [如何优化 Python 爬虫的速度？](http://www.zhihu.com/question/20145091)
    主要是判断准目前的瓶颈在哪里，网络io、磁盘io，还是cpu、内存等。然后在给出解决方案，io问题可以考虑添加硬件或者分布式；如果只cpu占用不饱和，可以考虑多线程、多进程、异步等，也的看具体情况。按照你的描述，猜测问题应该在cpu占用不饱和。

## Scrapy

### scrapy 安装
    $ sudo apt-get install python-dev libxml2-dev libxslt-dev
    $ pip install scrapy
scrapy 依赖Twisted，libxml，而Twisted，libxml安装时需要编译 C 代码，因此需要先安装python libxml 的开发包。

### REF
* [scrapy github](https://github.com/scrapy)
* [scrapy wiki github](https://github.com/scrapy/scrapy/wiki)
* [Recursively Scraping Web Pages With Scrapy](http://mherman.org/blog/2012/11/08/recursively-scraping-web-pages-with-scrapy/)
* [Scraping Web Pages With Scrapy](http://mherman.org/blog/2012/11/05/scraping-web-pages-with-scrapy/)
* [Crawl a website with scrapy](http://isbullsh.it/2012/04/Web-crawling-with-scrapy/) key words : scrapy, mogodb

## BeautifulSoup
    $ pip install beautifulsoup4
[BeautifulSoup doc](http://www.crummy.com/software/BeautifulSoup/bs4/doc/)

## [Twisted](http://twistedmatrix.com/trac/)
Twisted is an event-driven networking engine written in Python and licensed under the open source  MIT license. 
scrapy 基于 twisted
* [使用 Twisted Matrix 框架来进行网络编程](http://www.ibm.com/developerworks/cn/linux/network/l-twist/part1/index.html)

## python docs
http://docs.python.org/2/library/intro.html
file:///Users/apple/Downloads/python-2.7.5-docs-html/library/intro.html

## 对象属性遍历

import select
for i in select.__dict__:
    if type(select.__dict__[i]) == int:
        print i, select.__dict__[i]

__init__.py 文件。这些文件指示 Python 为您的包加载必要的库和特定的应用程序代码文件，它们都位于相同的目录中。

挑战一下[ 42qu 的笔试题](http://python.42qu.com/11290852)
请编写基于 requests 网络库的小爬虫，抓取新浪微话题的所有话题以及话题对应的简介

requests 抓取页面

[BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/)进行解析
下载[最新的源码](http://www.crummy.com/software/BeautifulSoup/bs4/download/beautifulsoup4-4.1.3.tar.gz)
[doc](www.crummy.com/software/BeautifulSoup/bs4/doc/)
** some questions **

- python 库文件依赖关系是如何处理的?
- virtualenv 的实现机制是什么，环境变量?

[42qu source code](https://bitbucket.org/zuroc/)

---

http://stackoverflow.com/questions/5904969/python-how-to-print-a-dictionarys-key

for key, value in mydic.iteritems() :
    print key, value

for key, value in mydic.items() :
    print (key, value)

for key in mydic.keys():
  print "the key name is" + key + "and its value is" + mydic[key]
