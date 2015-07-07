---
layout: post
title: Java环境变量
description: Java依赖三个环境变量，分别为JAVA_HOME，PATH和CLASSPATH。
tags: 后端
---

##JAVA_HOME

* 作用：指向jdk安装目录，供其他软件找到安装好的jdk
* 示例：<code>C:\Program Files\Java\jdk1.6.0_45</code>

##PATH

* 作用：列出了可执行文件的搜索路径，使得系统在任何路径下都可以识别java,javac命令
* 示例：<code>%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin\</code>

##CLASSPATH

* 作用：设置Classpath的目的，在于告诉Java执行环境，在哪些目录下可以找到您所要执行的Java程序所需要的类或者包
* 示例：<code>.;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar</code>