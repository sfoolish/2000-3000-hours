---

## Head First Java

实验网站，示例代码：http://www.headfirstlabs.com/books/hfjava/
书本链接：http://uet.vnu.edu.vn/~chauttm/e-books/java/Head-First-Java-2nd-edition.pdf

---

## [如何提升 Java 技术？](http://www.zhihu.com/question/19730466)

### 郭凛，软件手艺人，自学编程18年至今，创业中
J2EE是一滩很深的水，工程化也比较严重，如果一直做大项目的话，普通工程师可能一直都在用别人架构好的东西，很难接触到核心开发，也很难感受到J2EE的魅力所在
如果觉得自己基础已经差不多了，尝试自己独立从头开始完成一些项目（不一定是公司的，个人兴趣也可以，反正给自己定一个目标），会发现编程其实远不仅仅只是CRUD，Getter/Setter
多写代码，在写代码的过程中多看看用到的SDK/Framework的源码，少看书，多Google

[CURD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)In computer programming, create, read, update and delete (CRUD) are the four basic functions of persistent storage.

### 符冬，Java资深程序设计架构工程师
多做项目，多写代码，只有在项目开发当中遇到问题再去透彻的学习才能提升，没有目标的学习只会浪费时间和透支精力，熟能生巧，代码写的多了，技术自然就提升了

---

## [如何自学 Java？](http://www.zhihu.com/question/19945685/answer/13594055)

### 樊凯，Java-Android-创业者
首先先搞懂JavaSE的部分，Swing和swt部分就可以少看或不看，因为现在用的比较少。重点是看懂Java中的面向对象、集合框架、JDBC、异常、IO、线程和网络编程。JavaSE搞定后再学习Servlet、JSP,然后才是经典的Struts2、Hibernate和Spring，学习框架时重点理解框架的运行原理，甚至可以尝试自己写个轻量级的框架。理解运行原理的最好方法就是阅读源代码，还是要感谢Java中的开源项目。这期间还要多找各种大小的项目去完成，不一定要大，但是要精致，功能要完整，这样可以练习所学知识，并且可以在做项目中发现自己的知识体系中不足的地方。关于看视频，我不推荐，很多同学一天到晚就知道看视频，殊不知，编程真理在于“练习，练习，不停练习”！
再补充下：当学习Java的期间，会碰到各种各样的异常，请积累这些异常信息，以及如何出现的异常和如何处理的，因为java中常见的异常就那么几种，积累的多了，处理问题的能力就提高，这样水平会提高的很快！

---
## [java 学习路线图](http://edu.csdn.net/main/studyline/heimaline.html?flz)

Skilled in J2EE platform - JSP, Java, Servlet, EJB, Struts, Hibernate, Spring, Tomcat, JBoss, WebLogic 

## Java float 初始化
    
    $ cat Float.java 
    class Float{
    	public static void main(String arg[]) {
    		float f = 30.123;
    		System.out.println(f);
    	}
    }
    
    ϟSF-Hacking: ~/APP_PRJ/JAVA/workspace/ThinkingJava/src
    $ javac Float.java 
    Float.java:3: error: possible loss of precision
    		float f = 30.123;
    		          ^
      required: float
      found:    double
    1 error

Floating point literals are by default of double type. And assigning a double value to a float type will result in some precision error.

---

[浅谈Java中的Set、List、Map的区别](http://developer.51cto.com/art/201309/410205_all.htm)

    double d = 30.123;
    float c = 30.123f;