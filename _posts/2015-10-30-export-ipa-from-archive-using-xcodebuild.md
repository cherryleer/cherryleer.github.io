---
layout: post
title: iOS笔记：使用xcodebuild将archive导出为ipa
description: 由于Xcode7可以让开发者不用付费就能在手机上安装App，所以就心血来潮做了个App，用来载入博客。
tags: 后端
---

由于Xcode7可以让开发者不用付费就能在手机上安装App，所以就心血来潮做了个App，用来载入博客。

但是在用Xcode7生成Archive文件后，发现『export』按钮为灰色，无法将其导出为ipa文件。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/archives.jpg"/></p>

## **解决方案**

### **方案1: 注册开发者账号**

灰色区域下边有提示说需要去注册苹果开发者账号，按照提示去注册。

如果想要注册成功，必须付费。个人开发者账号每年688软妹纸，如果你打算上传到App Store，可以考虑购买；如果纯自己玩，成本就有点高了。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/enroll.jpg"/></p>

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/purchase.jpg"/></p>

### **方案2: 使用xcodebuild命令**

使用xcodebuild命令可以绕过需要开发者账号的限制，将你的应用打包成最终ipa。但是不能上传到App Store，不过对于纯自己玩的用户，已经足够了。

## **xcodebuild常用命令**

### **clean**

{% highlight bash %}
xcodebuild clean -project ${PROJECT_NAME}.xcodeproj \
                 -configuration ${CONFIGURATION} \
                 -alltargets
{% endhighlight %}

### **Archive**

{% highlight bash %}
xcodebuild archive -project ${PROJECT_NAME}.xcodeproj \
                   -scheme ${SCHEME_NAME} \
                   -destination generic/platform=iOS \
                   -archivePath bin/${PROJECT_NAME}.xcarchive
{% endhighlight %}

### **exportArchive**

{% highlight bash %}
xcodebuild -exportArchive -archivePath ${PROJECT_NAME}.xcarchive \
                          -exportPath ${PROJECT_NAME} \
                          -exportFormat ipa \
                          -exportProvisioningProfile ${PROFILE_NAME}
{% endhighlight %}

### **参数说明**

**${PROJECT_NAME}:** 项目名。

**${CONFIGURATION}:** 编译模式。Xcode默认会有两个编译模式：Debug和Release。Release下不能调试程序，编译时有做编译优化，比Debug打包出来的运行更快，包也更小。如果不设置，默认为Release。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/configuration.jpg"/></p>

**${PROFILE_NAME}:**

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/profile.jpg"/></p>

### **xcodebuild使用示例**

因为先前已经用Xcode7打包生成了Archive文件，所以这边只演示**exportArchive**命令。

{% highlight bash %}
xcodebuild -exportArchive -archivePath Cherryleer.xcarchive \
                          -exportPath Cherryleer \
                          -exportFormat ipa \
                          -exportProvisioningProfile iOS\ Team\ Provisioning\ Profile:\ com.cherryleer.blog
{% endhighlight %}

最后成功生成ipa文件。

<p class="picture"><img alt="" src="{{site.qiniu_static}}/assets/img/2015-10-30/result.jpg"/></p>

## **参考资料**

[苹果官网xcodebuild说明](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html)

[Reohou's Blog](http://blog.reohou.com/how-to-export-ipa-from-archive-using-xcodebuild)