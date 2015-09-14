---
layout: post
title: 使用七牛云存储为你的博客提速
description:
tags: 前端
---

现如今，很多技术人员都有这样一种习惯：搞个域名、搭个博客、写写文章。但是由于一些众所周知的原因，国内访问起来速度会比较慢。

其实有一些免费的方法，可以一定程度上改进这个问题，就是将博客的静态资源添加到国内的云存储空间上，然后博客在调用这些静态资源的时候直接去访问云存储空间。

本人使用的是Jekyll，搭建在GitHub Pages上。下面以七牛云存储为例，讲下操作方法。

### **注册账号**

[注册地址](https://portal.qiniu.com/signup)

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-9-14/register.png"/></p>

