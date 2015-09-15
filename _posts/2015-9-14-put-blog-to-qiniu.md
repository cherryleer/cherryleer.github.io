---
layout: post
title: 使用七牛云存储为你的博客提速
description:
tags: 前端
---

现如今，很多技术人员都有这样一种习惯：搞个域名、搭个博客、写写文章。但是由于一些众所周知的原因，国内访问起来速度会比较慢。

其实有一些免费的方法，可以一定程度上改进这个问题，就是将博客的静态资源添加到国内的云存储空间上，然后博客在调用这些静态资源的时候直接去访问云存储空间。

本人使用的是Jekyll，搭建在GitHub Pages上。下面以七牛云存储为例，讲下操作方法。

### **首先，注册账号**

注册地址：[https://portal.qiniu.com/signup](https://portal.qiniu.com/signup)

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/register.png"/></p>

### **创建用户空间**

登录账号，创建一个用户空间。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/namespace.png"/></p>


### **上传内容**

进入用户空间，选择内容管理，开始上传内容。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/upload.png"/></p>

上传成功后，文件显示如下。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/upload_success.png"/></p>

### **在博客中引用**

进入空间设置，记录七牛的域名，这个域名就是用来访问你的资源服务器的。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/domain.png"/></p>

在你博客中用该域名去替换原来的资源路径，这样在访问静态资源的时候，就转而去访问七牛云存储了。

**注意：** 如果觉得七牛的域名比较难记，可以在jekyll的config.yml配置文件中为它设个变量名，比如“qiniu_static”，这样调用的时候，就可以使用**site.qiniu_static**去替代了。