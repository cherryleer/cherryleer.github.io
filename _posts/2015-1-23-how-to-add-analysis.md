---
layout: post
title: 如何为博客添加第三方统计工具
description: 今天为博客添加了第三方的统计工具，用来记录博客的访问量。
tags: 前端
---

今天为博客添加了第三方的统计工具，用来记录博客的访问量。

目前市场上，免费的第三方统计工具有很多，最著名最牛逼的就是Google Analytics，但是只能放弃，原因你懂的。

国内市场上的统计工具一般有这么几种：

* 百度统计
* 腾讯分析
* CNNZ
* 51啦

由于BAT的品牌影响，今天暂时添加了前面两种，后面两种以后有时间再试试。

## 添加百度统计

* 首先需要一个[百度统计](http://tongji.baidu.com/)的账号
* 登录后，点击网站中心，在控制台的右上角点击新增网站

<p class="picture"><img alt="" src="/assets/img/2015-1-23/addSite.jpg"/></p>

* 输入你想要统计的网站url

<p class="picture"><img alt="" src="/assets/img/2015-1-23/addName.jpg"/></p>

* 将生成的js代码复制到你的网站

<p class="picture"><img alt="" src="/assets/img/2015-1-23/copyCode.jpg"/></p>

* 完成，过20分钟，进入控制台，查看统计数据

## 添加腾讯分析

添加腾讯分析的步骤也类似。

* 首先需要一个QQ账号（一般人都有）
* 进入[腾讯分析](http://v2.ta.qq.com/analysis/index)页面，用QQ账号登陆
* 登陆后，进入站点列表，点击新增站点，在出现的输入框中输入需要统计的网站url

<p class="picture"><img alt="" src="/assets/img/2015-1-23/addSiteToTX.jpg"/></p>

* 点击获取代码

<p class="picture"><img alt="" src="/assets/img/2015-1-23/getCode.jpg"/></p>

* 将生成的代码复制到你的网站

<p class="picture"><img alt="" src="/assets/img/2015-1-23/copyTXCode.jpg"/></p>

* 完成，过一会儿（感觉腾讯分析生效的时间略长，官网上也没有说明具体生效时间，百度官网写着是20分钟），进入控制台，查看统计数据
