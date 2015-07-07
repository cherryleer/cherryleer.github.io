---
layout: post
title: 如何为Repository添加自定义域名
description: 如果你想用自定义域名直接访问你的GitHub Pages站点，你必须创建并且提交一个包含自定义域名的CNAME文件到你的GitHub Pages repository。
tags: 前端
---

如果你想用自定义域名直接访问你的GitHub Pages站点，你必须创建并且提交一个包含自定义域名的CNAME文件到你的GitHub Pages repository。

注：

> 当你创建完CNAME文件后，GitHub Pages网站可能需要15分钟才会生效。如果创建不成功，你将会收到一封邮件。

## 开始

1. 在GitHub上，进入你的Pages repository。
2. 在Branches菜单，切到repository对应站点的分支：
  - 如果是用户或者组织站点，分支应为<code>master</code>。
  - 如果是项目站点，分支应为<code>gh-pages</code>。
3. 在分支的根目录下创建一个名为CNAME的文件
4. 在文件中，添加一行记录，该记录内容为你自定义域名的单独域名部分即可。比如，使用<code>blog.example.com</code>，而不是<code>http://blog.example.com</code>。注意，在CNAME文件中，只能有一个域名。
5. 提交新的变更。

## 确认自定义域名配置正确

在你repository的右侧导航栏，点击Settings。

<p class="picture"><img alt="" src="/assets/img/2013-2-10/setting.jpg"/></p>

在"GitHub Pages"下，你应该能看到CNAME中的自定义域名。

<p class="picture"><img alt="" src="/assets/img/2013-2-10/cherrylee_name.jpg"/></p>

## 设置DNS配置

当你在GitHub上创建并提交完CNAME文件后， 对你的DNS提供商做以下操作：

- 如果你的自定义域名是子域名，配置一条<code>CNAME</code>记录。
- 如果你的自定义域名是顶级域名，则配置<code>ALIAS</code>，<code>ANAME</code>或者<code>A</code>记录。