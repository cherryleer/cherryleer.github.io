---
layout: post
title: Java Object介绍
description: 在OOP中，自C++面试以来就已变得非常瞩目的一个问题就是，是否所有的类最终都继承自单一的基类。在Java中（事实上还包括除C++以外的所有OOP语言），答案是yes。
tags: 后端
---

## **概述**
在OOP中，自C++面试以来就已变得非常瞩目的一个问题就是，是否所有的类最终都继承自单一的基类。在Java中（事实上还包括除C++以外的所有OOP语言），答案是yes。

这个终极基类的名字就是Object。Object是每个类的祖先，是类层级的根源。每个类都使用Object作为超类。所有对象，包括数组，都实现这个类的方法。

这种单根继承结构保证所有对象都具备某些基本功能。因此你知道，在你的系统中你可以在每个对象上执行某些基本操作。

## **API预览**

**Object()** 默认构造方法。

**Class<?> getClass()** 返回该对象的运行时类。

**int hashCode()** 返回该对象的哈希码值。

**boolean equals(Object obj)** 指示某个其他对象是否与此对象“相等”。

**Object clone()** 创建并返回此对象的一个副本。

**String toString()** 返回该对象的字符串表示。

**void notify()** 唤醒在此对象监视器上等待的单个线程。

**void notifyAll()** 唤醒在此对象监视器上等待的所有线程。

**void wait()** 导致当前的线程等待，直到其他线程调用此对象的notify()或者notifyAll()方法。

**void wait(long timeout)** 导致当前的线程等待，直到其他线程调用此对象的notify()或notifyAll()方法，或者超过指定的时间量。

**void wait(long timeout,int nanos)** 导致当前的线程等待，直到其他线程调用此对象的 notify() 方法或 notifyAll() 方法，或者其他某个线程中断当前线程，或者已超过某个实际时间量。

**void finalize()** 当垃圾回收器确定不存在对该对象的更多引用时，由对象的垃圾回收器调用此方法。

