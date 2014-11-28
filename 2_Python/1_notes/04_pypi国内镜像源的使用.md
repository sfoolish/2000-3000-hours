## 使用国内镜像源来加速python pypi包的安装

国内有一些 PyPi 的镜像源如下：

* http://pypi.douban.com/ 豆瓣
* http://mirrors.aliyun.com/pypi/simple/ 阿里云
* http://pypi.sdutlinux.org/ 山东理工大学
* http://e.pypi.python.org/ 清华大学
* http://pypi.hustunique.com/ 华中理工大学
* http://pypi.mirrors.ustc.edu.cn 中国科学技术大学

手动指定源下载软件包，可以在 pip 后面跟 -i 来指定源，比如用豆瓣的源来安装 web2py ：

```sh

	pip install web2py -i http://pipy.douban.com/simple

```

Mac/Linux 下对镜像做全局配置，可以编辑 ~/.pip/pip.conf ，添加如下内容：

	[global]
	index-url=http://mirrors.aliyun.com/pypi/simple/
