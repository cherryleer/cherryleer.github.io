---
layout: post
title: 数据库笔记：DATETIME和TIMESTAMP
description: MySQL DATETIME和TIMESTAMP比较
tags: 后端
---

## **相同**
1. TIMESTAMP与DATETIME显示格式相同。显示宽度固定在19字符，格式为：YYYY-MM-DD HH:MM:SS。
2. TIMESTAMP与DATETIME查询格式相同。都是以 column_name='YYYY-MM-DD HH:MM:SS' 或 column_name>='YYYY-MM-DD HH:MM:SS' 格式查询。

## **不同**

### **1. 范围不同**

**DATETIME** 

支持的范围为 '1000-01-01 00:00:00' 到 '9999-12-31 23:59:59' 。DEFATUL值可以设置为范围内任意值，如 DEFAULT '1000-01-01 00:00:00'

**TIMESTAMP** 

支持的范围为 '1970-01-01 00:00:00' UTC 到 '2038-01-19 03:14:07' UTC 。DEFATUL值可以设置为范围内任意值，还可以设置 DEFAULT '0000-00-00 00:00:00'

### **2. 储存方式不同**

**TIMESTAMP**

1. 4个字节储存
2. 以UTC（Universal Time Coordinated，通用协调时）格式保存。
3. 时区转化 ，因为以以UTC格式保存，因此存储时转换成UTC，查询时根据MySQL会话时区设置转换回当前的时区（因此读到的结果跟MySQL会话时区相关，一般没影响）。

**DATETIME**

1. 8个字节储存，是TIMESTAMP的一倍。
2. 实际格式储存，存的什么就写什么。
3. 与时区无关，存的什么就读到什么。

## **TIMESTAMP 的一些其他的属性**
1. 字段不能定义DEFAULT NULL，也不能写入NULL(写入NULL会被转换成CURRENT_TIMESTAMP，或者DEFAULT值)。
2. TIMESTAMP字段个数的问题：
- DEFAULT值为'0000-00-00 00：00：00'或'2008-01-01 12:12:12'等具体具体数值的TIMESTAMP字段可以有随意个数。
- 没有DEFAULT值或者设置如下DEFAULT值，一个表中只能有一个：
- 不设置 DEFAULT 值 （不设置 DEFAULT 值等同于 DEFAULT CURRENT_TIMESTAMP） 
- DEFAULT CURRENT_TIMESTAMP 
- DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 

## **关于使用 int 直接存储 unix时间戳 的方式存储时间：**

因为 unix时间戳 实际是从1970年1月1日（UTC/GMT的午夜）开始所经过的秒数(不考虑闰秒，timestamp底层实际就是存储这一秒数)。所以很多同学直接用 int unsigned(跟timestamp一样，4字节无符号)来存储 unix时间戳 的方式来存储时间。

### **相对于 timestamp 和 datetime 用 int unsigned来存储 unix时间戳 的方式来存储时间有什么优缺点呢？**

### **优点**
1. 方便时间计算，直接 +/— 就能算出两个时间相差的秒数。

### **缺点**
1. 读取不方便，还需要转换一次才能得到人类能读懂的日期形式 YYYY-MM-DD HH:MM:SS ，但转换还算方便，MySQL 函数 from_unixtime(timestamp) 就能转换。
2. 功能相对于 timestamp 弱很多，不能 DEFAULT CURRENT_TIMESTAMP 或 DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP。

## **总结**
1. 当对范围没有要求的时候 DATETIME 和 TIMESTAMP 使用一模一样，但是TIMESTAMP具有更省空间、更强功能等诸多特点，强烈建议以 TIMESTAMP 替换 DATETIME。
2. 使用 int unsigned 存储时间戳的方式来存储时间不反对也不推荐(更推荐timestamp)，但使用的时候注意比较也要跟 unix时间戳 进行比较如果跟 YYYY-MM-DD HH:MM:SS 进行比较可能走不上索引而进行全部扫描。
