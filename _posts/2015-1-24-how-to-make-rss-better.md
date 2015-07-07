---
layout: post
title: 如何美化RSS
description: 在网上逛博客的时候，发现很多博客的RSS页面都很直白，就是一个赤裸裸的xml文档。而路透社等新闻网站，它们的RSS就做的相当好看。它们是如何实现的呢，今天我就仿照路透社，改造下RSS显示。
tags: 前端
---

在网上逛博客的时候，发现很多博客的RSS页面都很直白，就是一个赤裸裸的xml文档。

<p class="picture"><img alt="" src="/assets/img/2015-1-24/xml.jpg"/></p>

而路透社等新闻网站，它们的RSS就做的相当好看。

<p class="picture"><img alt="" src="/assets/img/2015-1-24/reuters.jpg"/></p>

它们是如何实现的呢，今天我就仿照[路透社](http://cn.reuters.feedsportal.com/chinaNews)，改造下RSS显示。

## 从一个原始的xml文档开始

<p class="picture"><img alt="" src="/assets/img/2015-1-24/origin_xml.jpg"/></p>

## 创建XSL样式表

仿照路透社的xsl文件，[下载地址](http://cherryleer.com/rss.xsl)

## 把XSL样式表链接到XML文档

<p class="picture"><img alt="" src="/assets/img/2015-1-24/addXSL.jpg"/></p>

## 查看结果

<p class="picture"><img alt="" src="/assets/img/2015-1-24/rssTest.jpg"/></p>

## 我的RSS

目前我的博客[RSS](http://cherryleer.com/rss.xml)也是仿照了路透社的样式，喜欢的同学可以下载[xsl模板](http://cherryleer.com/rss.xsl)。

<p class="picture"><img alt="" src="/assets/img/2015-1-24/cherry_rss.jpg"/></p>