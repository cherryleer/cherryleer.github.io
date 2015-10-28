---
layout: post
title: iOS笔记：iOS9不能载入HTTP网页问题
description:
tags: 后端
---

### **现象**

由于Xcode7可以让开发者不用付费就能在手机上安装App，所以就心血来潮做了个App，用来载入博客。

App很简单，就是在App启动的时候，初始化一个WebView，用来加载博客页面－“http://cherryleer.com”。

但是App运行的时候，出现了如下提示，且不见博客页面加载。

{% highlight xml %}
the resource could not be loaded because the app transport security policy requires the use of a secure connection
{% endhighlight %}

### **原因**

原因是iOS9引入了新特性App Transport Security (ATS)。

ATS要求App内访问的网络必须使用HTTPS协议，而我加载的是HTTP页面。

### **解决方案**

我知道的解决办法有两种：

1. 将加载的页面改为HTTPS，但实现起来需要一定的时间。
2. 在Info.plist中添加类型为Dictionary的NSAppTransportSecurity，并在其下添加类型为Boolean的NSAllowsArbitraryLoads，值设为YES。