---
layout: post
title: 读书笔记：Java内存模型
description: Java虚拟机规范中，试图定义一种Java内存模型来屏蔽各种硬件和操作系统的内存访问差异，以实现让Java程序在各种平台下都能达到一致的内存访问效果。
tags: 后端
---

Java虚拟机规范中，试图定义一种Java内存模型来屏蔽各种硬件和操作系统的内存访问差异，以实现让Java程序在各种平台下都能达到一致的内存访问效果。

定义Java内存模型并不是一件容易的事情，这个模型必须定义的足够严谨，才能让Java的并发内存访问操作不会产生歧义；但是，也必须定义的足够宽松，使得虚拟机的实现有足够的自由空间去利用硬件的各种特性来获取更好的执行速度。

## **主内存与工作内存**

Java内存模型的主要目标是定义程序中各个变量的访问规则，即在虚拟机中将变量存储到内存和从内存中取出变量这样的底层细节。

Java内存模型规定了所有的变量都存储在主内存中。每条线程还有自己的工作内存，线程的工作内存中保存了被该线程使用到的变量的主内存副本拷贝，线程对变量的所有操作都必须在工作内存中进行，而不能直接读写主内存中的变量。不同的线程之间也无法访问对方工作内存中的变量，线程间变量值的传递均需要通过主内存来完成。

线程、主内存、工作内存三者的交互关系如下图所示:

<p class="picture"><img alt="" src="/assets/img/2015-6-3/mem_relation.jpg"/></p>

## **内存间交互操作**

关于主内存与工作内存之间的具体交互协议，即一个变量如何从主内存拷贝到工作内存、如何从工作内存同步回主内存之类的实现细节，Java内存模型定义了一下8个操作来完成，虚拟机必须保证下面提及的每一种操作都是原子的、不可再分的。

* **lock：** 作用于主内存的变量，它把一个变量标示为一条线程独占的状态;
* **unlock：** 作用于主内存的变量，它把一个处于锁定状态的变量释放出来，释放后的变量才可以被其他线程锁定;
* **read：** 作用于主内存的变量，它把一个变量的值从主内存传输到线程的工作内存中，以便随后的load操作;
* **load：** 作用于工作内存的变量，它把read操作从主内存中得到的变量值放入到工作内存的变量副本中;
* **use：** 作用于工作内存的变量，它把工作内存中一个变量的值传递给执行引擎，每当虚拟机遇到一个需要使用到变量的值的字节码指令时将会执行这个操作;
* **assign：** 作用于工作内存的变量，它把一个从执行引擎接收到的值赋给工作内存的变量，每当虚拟机遇到一个给变量赋值的字节码指令时执行这个操作;
* **store：** 作用于工作内存的变量，它把工作内存中的一个变量的值传送到主内存中，以便随后的write操作使用;
* **write：** 作用于主内存的变量，它把store操作从工作内存中得到的变量的值放入主内存的变量中。

如果要把一个变量中主内存复制到工作内存呢，那就要顺序的执行read和load操作，如果要把变量从工作内存同步回主内存，就要顺序的执行store和write操作。

* **注意：** Java内存模型只要求上述两个操作必须按顺序执行，而没有保证是连续执行。

除此之外，Java内存模型还规定了在执行上述8种基本操作时必须满足如下规则：

* 不允许read和load、store和write操作之一单独出现，即不允许一个变量从主内存读取了但工作内存不接受，或者从工作内存发起了但主内存不接受的情况出现;
* 不允许一个线程丢弃它的最近的assign操作，即变量在工作内存中改变了之后必须把该变化同步回主内存;
* 不允许一个线程无故地（没有发生任何assign操作）把数据从线程的工作内存中同步回主内存中;
* 一个新的变量只能在主内存中“诞生”，不允许在工作内存中直接使用一个未被初始化（load或assign）的变量，换句话说，就是对一个看两实施use、store操作之前，必须先执行过了assign和load操作;
* 一个变量在同一个时刻只允许一条线程对其进行lock操作，但lock操作可以被同一条线程重复执行多次，多次lock后，只有执行相同次数的unlock操作，变量才会被解锁;
* 如果一个变量执行lock操作，那将会清空工作内存中此变量的值，在执行引擎使用这个变量钱，需要重新执行load或assign操作初始化变量的值;
* 如果一个变量事先没有被lock操作锁定，那就不允许对它执行unlock操作，也不允许去unlock一个被其他线程锁定住的变量; 
* 对一个变量执行unlock操作之前，必须先把此变量同步回主内存中（执行store、write操作）。

这8种内存访问操作以及上述规则限定，再加上对volatile的一些特殊规定，就已经完全确定了Java程序中哪些内存访问操作在并发下是安全的。
