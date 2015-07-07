---
layout: post
title: 读书笔记：HTTP Cookie，Session比较
description: HTTP协议是一种无状态的协议，也就是说，当前的HTTP请求与以前的HTTP请求没有任何联系。显然，这种无状态的情形在某些时候将让用户觉得非常麻烦，比如在网上商城购物时，每购买一个商品都要重新输入一次用户名和密码，用户很快就会失去耐心，而且反复的输入也产生了更大的风险。所以，Web访问通过使用Cookie和Session解决这个问题。
tags: 网络
---

HTTP协议是一种无状态的协议，也就是说，当前的HTTP请求与以前的HTTP请求没有任何联系。

显然，这种无状态的情形在某些时候将让用户觉得非常麻烦，比如在网上商城购物时，每购买一个商品都要重新输入一次用户名和密码，用户很快就会失去耐心，而且反复的输入也产生了更大的风险。

所以，Web访问通过使用Cookie和Session解决这个问题。

## **Cookie**

[了解HTTP Cookie，戳这里](http://cherryleer.com/network/2015/03/30/http-cookie-introduction.html)

## **Session**

[了解HTTP Session，戳这里](http://cherryleer.com/network/2015/03/30/http-session-introduction.html)

## **Cookie vs Session**

Cookie和Session的差异主要体现在以下几个方面：

### **应用场景**
 
* Cookie的典型应用场景是Remember Me服务，即用户包括账户在内的关键信息通过Cookie文件的形式保存在客户端，当用户再次请求匹配的URL的时候，Cookie信息会被传送到服务端，交由相应的程序完成自动登录等功能;
 
* Session的典型应用场景是用户登录某网站之后，服务器将其登录信息以及其他关键信息放入由一个Session ID关联的数据库或文件中，在以后的每次请求中都检验Session ID来确保该用户合法。
 
### **安全性**

* Cookie将一些信息保存在客户端，如果不进行加密的话，无疑会暴露一些隐私信息，安全性很差，一般情况下敏感信息是经过加密后存储在Cookie中，但也很容易被窃取;

* Session主要将信息存储在服务器端，如果存储在文件或数据库中，也有被窃取的可能，只是这种可能性非常小。

Session与Cookie在安全性方面都存在会话劫持的问题，即在网络通信中被攻击者捕获而用来冒充真正用户。总体来讲，Session的安全性要高于Cookie。

### **性能**

* Cookie存储在客户端，消耗的是客户端的I/O和内存，因此Cookie很好的分散了性能消耗;
* Session存储在服务器端，消耗的是服务器端的资源，所以Session对服务器造成的压力比较集中。

从这点来看，Cookie要好于Session。

### **时效性**

* Cookie可以通过设置有效期使其在较长时间内存在于客户端;
* Session一般只有比较短的有效期（用户主动清除Session或过期超时）。

### **其他**

Cookie的处理在开发中没有Session方便，而且Cookie在客户端的存储是有大小和数量的限制的，而Session的存储只收到硬件的限制，能存储的数据无疑大了许多。