# Elipse + JDK + Maven 安装

## 下载安装 Eclipse

到 [Eclipse Downloads](https://www.eclipse.org/downloads/) 下载 eclipse-standard-kepler-SR2-macosx-cocoa-x86_64.tar.gz，解压即可用。

## 下载安装 JDK

到 [Java SE Development Kit 7 Downloads](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) 下载 jdk-7u51-macosx-x64.dmg ，双击按提示默认安装，安装完毕后打开终端，导出环境变量： `export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home/jre` ，将这行命令添加到`~/.profile` 能永久生效。

## 下载安装 Maven

到 [Download Apache Maven 3.2.1](http://maven.apache.org/download.cgi) 下载 apache-maven-3.2.1-bin.tar.gz，然后，解压到指定路径 `tar xvf apache-maven-3.2.1-bin.tar.gz`，解压完毕后，创建软连接 `cd /usr/bin ; ln -s /path/apache-maven-3.2.1/bin/mvn mvn; cd -`。至此，Maven安装完毕。

不过，建议最后修改一下 Maven 库的镜像路径。`apache-maven-3.2.1/conf/settings.xml` 是默认的配置文件。

创建相关文件及文件夹

    mkdir -p ~/.m2/repository/
    cp /path/apache-maven-3.2.1/conf/settings.xml ~/.m2/

修改配置文件 ~/.m2/settings.xml，这里用了开源中国提供的库

    <settings>
      ...
      <mirrors>
        <mirror>
          <id>oschina</id>
          <name>OS China</name>
          <url>http://maven.oschina.net/content/groups/public/</url>
          <mirrorOf>* </mirrorOf>
        </mirror>
      </mirrors>
      ...
    </settings>

## Eclipse 安装 m2eclipse 插件

添加插件路径：菜单路径：`Help -> Install new software... -> add` ，添加内容 `m2e - http://download.eclipse.org/technology/m2e/releases` 

然后，按提示安装 m2eclipse(Maven Integration for Eclipse)。

## 参考链接

* [使用Eclipse构建Maven项目 (step-by-step)](http://blog.csdn.net/qjyong/article/details/9098213)
* [开源中国 Maven 库使用帮助](http://maven.oschina.net/help.html)
* [Using Mirrors for Repositories](http://maven.apache.org/guides/mini/guide-mirror-settings.html)
