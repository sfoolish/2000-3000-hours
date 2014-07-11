## Maven 简介

Maven 是一个项目管理和构建自动化工具。但是对于我们程序员来说，我们最关心的是它的项目构建功能。
Maven 使用惯例优于配置的原则 。

## Maven 安装

	详见：[00_jdk-maven-eclipse.md](00_jdk-maven-eclipse.md)

## Maven 基本功能的使用

	$ mvn archetype:generate -DgroupId=com.mycompany.helloworld -DartifactId=helloworld -Dpackage=com.mycompany.helloworld -Dversion=1.0-SNAPSHOT
	$ cd helloworld
	$ mvn package
	$ java -cp target/helloworld-1.0-SNAPSHOT.jar com.mycompany.helloworld.App

### REF

* [Apache Maven 入门篇 ( 上 )](http://www.oracle.com/technetwork/cn/community/java/apache-maven-getting-started-1-406235-zhs.html)
* [Apache Maven 入门篇(下)](http://www.oracle.com/technetwork/cn/community/java/apache-maven-getting-started-2-405568-zhs.html)

