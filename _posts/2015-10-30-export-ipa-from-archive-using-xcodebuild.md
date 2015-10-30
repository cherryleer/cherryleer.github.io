---
layout: post
title: iOS笔记：使用xcodebuild将archive导出为ipa
description: 使用xcodebuild将archive导出为ipa
tags: 后端
---

## **现象**

由于Xcode7可以让开发者不用付费就能在手机上安装App，所以就心血来潮做了个App，用来载入博客。

但是在用Xcode7生成Archive文件后，发现『export』按钮为灰色，无法将其导出为ipa文件。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/archives.jpg"/></p>

## **解决方案**

### **方案1: 注册开发者账号**

灰色区域下边有提示说需要去注册苹果开发者账号，按照提示去注册。

如果想要注册成功，必须付费，个人开发者账号每年699，如果你打算上传到App Store，可以考虑购买，如果纯自己玩，成本就有点高了。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/enroll.jpg"/></p>

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/purchase.jpg"/></p>

### **方案2: 使用xcodebuild命令**

常用的命令有：

#### **clean**

{% highlight bash %}
xcodebuild clean -project ${PROJECT_NAME}.xcodeproj \
                 -configuration ${CONFIGURATION} \
                 -alltargets
{% endhighlight %}

#### **Archive**

{% highlight bash %}
xcodebuild archive -project ${PROJECT_NAME}.xcodeproj \
                   -scheme ${SCHEME_NAME} \
                   -destination generic/platform=iOS \
                   -archivePath bin/${PROJECT_NAME}.xcarchive
{% endhighlight %}

#### **clean**

{% highlight bash %}
xcodebuild -exportArchive -archivePath ${PROJECT_NAME}.xcarchive \
                          -exportPath ${PROJECT_NAME} \
                          -exportFormat ipa \
                          -exportProvisioningProfile ${PROFILE_NAME}
{% endhighlight %}