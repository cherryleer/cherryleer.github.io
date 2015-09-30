---
layout: post
title: 大数据笔记：Mac Hadoop安装
description:
tags: 后端
---

## **简介**
Hadoop是一个由Apache基金会所开发的分布式系统基础架构。

用户可以在不了解分布式底层细节的情况下，开发分布式程序。充分利用集群的威力进行高速运算和存储。

## **目的**

本文详细介绍Hadoop在Mac上的安装过程。

由于使用Homebrew安装完Hadoop后，启动总是有问题，网上查了很多资料，才算搞定，所以写篇博客纪录下。

## **基础环境准备**

* Mac OS X Yosemite（10.10.5）
* JDK 1.7.0_75
* Hadoop 2.6.0

### **安装JDK**

* JDK下载安装，[戳这里](http://www.oracle.com/technetwork/cn/java/javase/downloads/index.html)
* 环境变量设置，[戳这里](http://cherryleer.com/2012/10/02/java-env-variables)

验证配置是否成功：

<p class="picture"><img alt="" src="/assets/img/2015-10-1/java_home.png"/></p>

### **SSH免密码登录**

* SSH免密码登录过程，[戳这里](http://cherryleer.com/2015/03/24/ssh-login)
* 常见问题：ssh localhost异常，[戳这里](http://cherryleer.com/2015/09/30/ssh-localhost)

验证配置是否成功：

<p class="picture"><img alt="" src="/assets/img/2015-10-1/ssh_localhost.png"/></p>

## **Hadoop安装**

### **下载Hadoop**

官方下载地址：http://hadoop.apache.org/releases.html#Download，我选择的是2.6.0版本。

下载后，解压到指定目录。

{% highlight bash %}
tar -zxf hadoop-2.6.0.tar.gz -C /usr/local/share
{% endhighlight %}

