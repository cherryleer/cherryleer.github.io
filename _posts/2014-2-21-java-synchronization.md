---
layout: post
title: Java同步
description: 线程间的通信主要是通过共享域和引用相同的对象。这种通信方式非常高效，不过可能会引发两种错误：线程干扰和内存一致性错误。防止这些错误发生的方法是同步。
tags: 翻译 后端
---

[原文链接](http://docs.oracle.com/javase/tutorial/essential/concurrency/sync.html)，[译文链接](http://ifeve.com/synchronization/)，译者：蘑菇街-小宝，[Greenster](http://ifeve.com/author/29878739/)，[李任](http://ifeve.com/author/cherrylee/)  校对：丁一，郑旭东，[李任](http://ifeve.com/author/cherrylee/)

线程间的通信主要是通过共享域和引用相同的对象。这种通信方式非常高效，不过可能会引发两种错误：线程干扰和内存一致性错误。防止这些错误发生的方法是同步。

不过，同步会引起线程竞争，当两个或多个线程试图同时访问相同的资源，随之就导致Java运行时环境执行其中一个或多个线程比原先慢很多，甚至执行被挂起，这就出现了线程竞争。线程饥饿和活锁都属于线程竞争的范畴。关于线程竞争的更多信息可参考活跃度一节。

本节内容包括以下这些主题：

*   **线程干扰**讨论了当多个线程访问共享数据时错误是怎么发生的。
*   **内存一致性错误**讨论了不一致的共享内存视图导致的错误。
*   **同步方法**讨论了 一种能有效防止线程干扰和内存一致性错误的常见做法。
*   **内部锁和同步**讨论了更通用的同步方法，以及同步是如何基于内部锁实现的。
*   **原子访问**讨论了不能被其他线程干扰的操作的总体思路。

## 线程干扰

[原文链接](http://docs.oracle.com/javase/tutorial/essential/concurrency/interfere.html)

下面这个简单的Counter类：

{% highlight java %}
class Counter {
    private int c = 0;
    public void increment() {
        c++;
    }
    public void decrement() {
        c--;
    }
    public int value() {
        return c;
    }
}
{% endhighlight %}

Counter类被设计成：每次调用increment()方法，c的值加1；每次调用decrement()方法，c的值减1。如果当同一个Counter对象被多个线程引用，线程间的干扰可能会使结果同我们预期的不一致。

当两个运行在不同的线程中却作用在相同的数据上的操作交替执行时，就发生了线程干扰。这意味着这两个操作都由多个步骤组成，而步骤间的顺序产生了重叠。

Counter类实例的操作会交替执行，这看起来似乎不太可能，因为c上的这两个操作都是单一而简单的语句。然而，即使一个简单的语句也会被虚拟机转换成多个步骤。我们不去深究虚拟机内部的详细执行步骤——理解c++这个单一的语句会被分解成3个步骤就足够了：

1.  _获取当前c的值；_
2.  _对获取到的值加1；_
3.  _把递增后的值写回到c；_
语句c--也可以按同样的方式分解，除了第二步的操作是递减而不是递增。

假设线程A调用increment()的同时线程B调用decrement().如果c的初始值为0，线程A和B之间的交替执行顺序可能是下面这样：

_线程A：获取c；_
_线程B：获取c；_
_线程A：对获取的值加1，结果为1；_
_线程B：对获取的值减1，结果为-1；_
_线程A：结果写回到c,c现在是1；_
_线程B：结果写回到c,c现在是-1；_

线程A的结果因为被线程B覆盖而丢失了。这个交替执行的结果只是其中一种可能性。在不同的环境下，可能是线程B的结果丢失了，也可能是不会出任何问题。由于结果是不可预知的，所以线程干扰的bug很难检测和修复。

## 内存一致性错误

[原文链接](http://docs.oracle.com/javase/tutorial/essential/concurrency/memconsist.html "原文链接")

当不同的线程对相同的数据产生不一致的视图时会发生内存一致性错误。内存一致性错误的原因比较复杂，也超出了本教程的范围。不过幸运的是，一个程序员并不需要对这些原因有详细的了解。所需要的是避免它们的策略。

避免内存一致性错误的关键是理解happens-before关系。这种关系只是确保一个特定语句的写内存操作对另外一个特定的语句可见。要说明这个问题，请参考下面的例子。假设定义和初始化了一个简单int字段：

{% highlight java %}
  int counter =0 ;
{% endhighlight %}

这个counter字段被A，B两个线程共享。假设线程A对counter执行递增:

{% highlight java %}
  counter++;
{% endhighlight %}

然后，很快的，线程B输出counter:

{% highlight java %}
  System.out.println(counter);
{% endhighlight %}

如果这两个语句已经在同一个线程中被执行过，那么输出的值应该是“1”。不过如果这两个语句在不同的线程中分开执行，那输出的值很可能是“0”，因为无法保证线程A对counter的改动对线程B是可见的——除非我们在这两个语句之间已经建立了happens-before关系。

有许多操作会建立happens-before关系。其中一个是同步，我们将在下面的章节中看到。

我们已经见过两个建立happens-before关系的操作。

*   当一条语句调用Thread.start方法时，和该语句有happens-before关系的每一条语句，跟新线程执行的每一条语句同样有happens-before关系。创建新线程之前的代码的执行结果对线新线程是可见的。
*   当一个线程终止并且当导致另一个线程中Thread.join返回时，被终止的线程执行的所有语句和在join返回成功之后的所有语句间有happens-before关系。线程中代码的执行结果对执行join操作的线程是可见的。
要查看建立happens-before关系的操作列表，请参阅java.util.concurrent包的[摘要页面](http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html#MemoryVisibility " Summary page of the java.util.concurren")。

## 同步方法

[原文地址](http://docs.oracle.com/javase/tutorial/essential/concurrency/syncmeth.html)

Java编程语言提供两种同步方式：同步方法和同步语句。相对较复杂的同步语句将在下一节中介绍。本节主要关注同步方法。

要让一个方法成为同步方法，只需要在方法声明中加上synchronized关键字：

{% highlight java %}
public class SynchronizedCounter {
    private int c = 0;

    public synchronized void increment() {
        c++;
    }

    public synchronized void decrement() {
        c--;
    }

    public synchronized int value() {
        return c;
    }
}
{% endhighlight %}

如果_count_是_SynchronizedCounter_类的实例，那么让这些方法成为同步方法有两个作用:

*   首先，相同对象上的同步方法的两次调用，它们要交替执行是不可能的。 当一个线程正在执行对象的同步方法时，所有其他调用该对象同步方法的线程会被阻塞（挂起执行）,直到第一个线程处理完该对象。
*   其次，当一个同步方法退出时，它会自动跟该对象同步方法的任意后续调用建立起一种_happens-before_关系。这确保对象状态的改变对所有线程是可见的。
注意构造方法不能是同步的——构造方法加_synchronized_关键字会报语法错误。同步的构造方法没有意义，因为当这个对象被创建的时候，只有创建对象的线程能访问它。

警告：当创建的对象会被多个线程共享时必须非常小心，对象的引用不要过早“暴露”出去。比如，假设你要维护一个叫_instances_的_List_，它包含类的每一个实例对象。你可能会尝试在构造方法中加这样一行：

{% highlight java %}
  instances.add(this);
{% endhighlight %}

不过其他线程就能够在对象构造完成之前使用_instances_访问对象。

同步(_synchronized_)方法使用一种简单的策略来防止线程干扰和内存一致性错误：如果一个对象对多个线程可见，对象域上的所有读写操作都是通过_synchronized_方法来完成的。（一个重要的例外：_final_域，在对象被创建后不可修改,能被非_synchronized_方法安全的读取）。_synchronized_同步策略很有效，不过会引起活跃度问题，我们将在本节后面看到。

## 内部锁与同步

[原文链接](http://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html)

同步机制的建立是基于其内部一个叫内部锁或者监视锁的实体。（在Java API规范中通常被称为监视器。）内部锁在同步机制中起到两方面的作用：对一个对象的排他性访问；建立一种happens-before关系，而这种关系正是可见性问题的关键所在。

每个对象都有一个与之关联的内部锁。通常当一个线程需要排他性的访问一个对象的域时，首先需要请求该对象的内部锁，当访问结束时释放内部锁。在线程获得内部锁到释放内部锁的这段时间里，我们说线程拥有这个内部锁。那么当一个线程拥有一个内部锁时，其他线程将无法获得该内部锁。其他线程如果去尝试获得该内部锁，则会被阻塞。

当线程释放一个内部锁时，该操作和对该锁的后续请求间将建立happens-before关系。

### 同步方法中的锁

当线程调用一个同步方法时，它会自动请求该方法所在对象的内部锁。当方法返回结束时则自动释放该内部锁，即使退出是由于发生了未捕获的异常，内部锁也会被释放。

你可能会问调用一个静态的同步方法会如何，由于静态方法是和类（而不是对象）相关的，所以线程会请求类对象(Class Object)的内部锁。因此用来控制类的静态域访问的锁不同于控制对象访问的锁。

### 同步块

另外一种同步的方法是使用同步块。和同步方法不同，同步块必须指定所请求的是哪个对象的内部锁：

{% highlight java %}
public void addName(String name) {
    synchronized(this) {
        lastName = name;
        nameCount++;
    }
    nameList.add(name);
}
{% endhighlight %}

在上面的例子中，addName方法需要使lastName和nameCount的更改保持同步，而且要避免同步调用该对象的其他方法。（在同步代码中调用其他方法会产生[Liveness](http://docs.oracle.com/javase/tutorial/essential/concurrency/liveness.html)一节所描述的问题。）如果不使用同步块，那么必须要定义一个额外的非同步方法，而这个方法仅仅是用来调用nameList.add。
使用同步块对于更细粒度的同步很有帮助。例如类MsLunch有两个实例域c1和c2，他们并不会同时使用（译者注：即c1和c2是彼此无关的两个域），所有对这两个域的更新都需要同步，但是完全不需要防止c1的修改和c2的修改相互之间干扰（这样做只会产生不必要的阻塞而降低了并发性）。这种情况下不必使用同步方法，可以使用和this对象相关的锁。这里我们创建了两个“锁”对象（译者注：起到加锁效果的普通对象lock1和lock2）。

{% highlight java %}
public class MsLunch {
    private long c1 = 0;
    private long c2 = 0;
    private Object lock1 = new Object();
    private Object lock2 = new Object();

    public void inc1() {
        synchronized(lock1) {
            c1++;
        }
    }

    public void inc2() {
        synchronized(lock2) {
            c2++;
        }
    }
}
{% endhighlight %}

使用这种方法时要特别小心，需要十分确定c1和c2是彼此无关的域。

### 可重入同步

还记得吗，一个线程不能获得其他线程所拥有的锁。但是它可以获得自己已经拥有的锁。允许一个线程多次获得同一个锁实现了可重入同步。这里描述了一种同步代码的场景，直接的或间接地，调用了一个也拥有同步代码的方法，且两边的代码使用的是同一把锁。如果没有这种可重入的同步机制，同步代码则需要采取许多额外的预防措施以防止线程阻塞自己。

## 原子访问

[原文链接](http://docs.oracle.com/javase/tutorial/essential/concurrency/atomic.html)

在编程过程中，原子操作是指所有操作都同时发生。原子操作不能被中途打断：要么全做，要么不做。原子操作在完成前不会有看得见的副作用。

我们发现像`c++`这样的增量表达式，并没有描述原子操作。即使是非常简单的表达式也能够定义成能被分解为其他操作的复杂操作。然而，有些操作你可以定义为原子的：

*   对引用变量和大部分基本类型变量（除long和double之外）的读写是原子的。
*   对所有声明为volatile的变量（包括long和double变量）的读写是原子的。
原子操作不会交错，于是可以放心使用，不必担心线程干扰。然而，这并不能完全消除原子操作上的同步，因为内存一致性错误仍可能发生。使用volatile变量可以降低内存一致性错误的风险，因为对volatile变量的任意写操作，对于后续在该变量上的读操作建立了happens-before关系。这意味着volatile变量的修改对于其他线程总是可见的。更重要的是，这同时也意味着当一个线程读取一个volatile变量时，它不仅能看到该变量最新的修改，而且也能看到致使该改变发生的代码的副效应。

使用简单的原子变量访问比通过同步代码来访问更高效，但是需要程序员更加谨慎以避免内存一致性错误。至于这额外的付出是否值得，得看应用的大小和复杂度。

`java.util.concurrent`包中的一些类提供了一些不依赖同步机制的原子方法。我们将在高级并发对象这一节中讨论它们。