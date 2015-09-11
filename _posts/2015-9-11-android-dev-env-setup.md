---
layout: post
title: Android笔记：Android开发环境搭建
description: 由于本人使用的是Mac，所以纪录Mac下Android开发环境的搭建方式。
tags: 后端
---

由于本人使用的是Mac，所以纪录Mac下Android开发环境的搭建方式。

## **Android开发环境要求**

* 一台电脑；
* JDK（**JDK6以上，Android5.0以上至少需要JDK7**）；
* SDK；
* Android Studio。

## **安装JDK**

* JDK下载安装，[戳这里](http://www.oracle.com/technetwork/cn/java/javase/downloads/index.html)
* 环境变量设置，[戳这里](http://cherryleer.com/2012/10/02/java-env-variables)

## **安装SDK**

* Android Studio下载安装，[戳这里](http://developer.android.com/sdk/index.html)

## **安装SDK**

在Android Studio中，在工具栏中点击"SDK Manager"，或者点击“Tools－Android－SDK Manager”，打开SDK Manager。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-11/sdk-manager.jpg"/></p>

### **安装SDK Tools**

* 打开**Tools**文件夹
* 选择**Android SDK Tools**
* 选择**Android SDK Platform-tools**
* 选择**Android SDK Build-tools(最新版)**
* 打开最新版的**Android X.X**文件夹
* 选择**SDK Platform**

### **安装扩展API**

* 打开**Extras**文件夹
* 选择**Android Support Repository**
* 选择**Android Support Library**
* 选择**Google Repository**
* 选择**Google Play services**

### **配置Proxy**

如果下载SDK失败，可以安装代理。

* 启动Android SDK Manager；
* 选择「Tools」、「Options...」，弹出『Android SDK Manager - Settings』窗口；
* 在『Android SDK Manager - Settings』窗口中，在「HTTP Proxy Server」和「HTTP Proxy Port」输入框内填入mirrors.neusoft.edu.cn和80；
* 选中「Force https://... sources to be fetched using http://...」复选框；
* 设置完成后单击「Close」按钮关闭『Android SDK Manager - Settings』窗口返回到主界面；
* 依次选择「Packages」、「Reload」。

**注意：**

* 中科院开源协会镜像：mirrors.opencas.cn
* 备用服务器地址：mirrors.opencas.org、mirrors.opencas.ac.cn

参考地址：[http://developer.android.com/sdk/installing/index.html](http://developer.android.com/sdk/installing/index.html)