---
layout: post
title: 读书笔记：两阶段提交协议
description: 两阶段提交协议（Two-phase Commit, 2PC）是指，在计算机网络以及数据库领域内，为了使基于分布式系统架构下的所有节点在进行事务提交时，保持一致性而设计的一种协议。
description: 两阶段提交协议（Two-phase Commit, 2PC）是指，在计算机网络以及数据库领域内，为了使基于分布式系统架构下的所有节点在进行事务提交时，保持一致性而设计的一种协议。
tags: 网络
---

## **事务**

事务是数据库操作的基本单位，它具有ACID四个基本属性，即原子性、一致性、隔离性和持久性。

### **原子性（Atomicity）**
事务的原子性体现在事务对数据的修改，要么全都执行，要么全都不执行。

### **一致性（Consistency）**
事务的一致性体现在事务必须使得数据库从一个一致性状态到另一个一致性状态。由原子性可知，事务必须满足一致性。

### **隔离性（Isolation）**
事务的隔离性是指一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能相互干扰。

### **持久性（Durability）**
事务的持久性是指事务一旦提交，它对数据库的改变是持久的。

这些属性在单机事务中比较容易满足。但是在分布式系统中，当一个事务需要跨越多个节点时，实现起来就比较困难。因为每个节点虽然可以知道自己的操作是否成功，但不清楚其他节点的操作是否也成功。因此便需要引入一个协调者来统一掌控所有参与事务的节点，来协调最后事务是提交还是回滚。

## **两阶段提交**
两阶段提交协议（Two-phase Commit, 2PC）是指，在计算机网络以及数据库领域内，为了使基于分布式系统架构下的所有节点在进行事务提交时，保持一致性而设计的一种协议。

在两阶段协议中，系统一般包括两类节点：协调者（coordinator）和参与者（cohorts）。一般协调者只有一个，而参与者有多个。

### **前提**
两阶段提交协议的成立基于以下假设：

1. 分布式系统中，存在一个作为协调者的节点，其余节点作为参与者，且各节点间可以相互通信；
2. 所有节点都采用预写式日志，且日志被写入后即被保持在可靠的存储设备上，即使节点损坏不会导致日志数据的消失；
3. 所有节点不会永久性损坏，即使损坏后仍然可以恢复。

### **执行过程**
在正常的执行过程中，这两个阶段的执行过程如下：

* **阶段1:请求阶段（Prepare Phase）**

在请求阶段，协调者通知事务参与者准备提交或者取消事务，然后进入表决过程。在表决过程中，参与者将告知协调者自己的决策：同意（事务参与者本地执行成功）或者取消（事务参与者本地执行失败）。 

* **阶段2:提交阶段（Commit Phase）**

在提交阶段，协调者将基于第一个阶段的投票结果进行决策：提交或者取消。当且仅当所有的参与者同意提交事务协调者才通知所有的参与者提交事务，否则协调者通知所有的参与者取消事务。参与者在接收到协调者发来的消息后将执行相应的操作。

### **缺点**
二阶段提交算法的最大缺点就在于 它的执行过程中间，节点都处于阻塞状态。即节点之间在等待对方的相应消息时，它将什么也做不了。特别是，当一个节点在已经占有了某项资源的情况下，为了等待其他节点的响应消息而陷入阻塞状态时，当第三个节点尝试访问该节点占有的资源时，这个节点也将连带陷入阻塞状态。

另外，协调者节点指示参与者节点进行提交等操作时，如有参与者节点出现了崩溃等情况而导致协调者始终无法获取所有参与者的响应信息，这是协调者将只能依赖协调者自身的超时机制来生效。但往往超时机制生效时，协调者都会指示参与者进行回滚操作。这样的策略显得比较保守。






