---
layout: post
title: JVM笔记：Java关键字volatile
description: 关键字volatile是Java虚拟机提供的最轻量级的同步机制，但是它并不容易被完全正确、完整的理解，以至于许多程序员在处理并发问题时，乱用、错用。于是，花一些时间弄清楚volatile的语义就显得至关重要。
tags: 后端
---

关键字volatile是Java虚拟机提供的最轻量级的同步机制，但是它并不容易被完全正确、完整的理解，以至于许多程序员在处理并发问题时，乱用、错用。于是，花一些时间弄清楚volatile的语义就显得至关重要。

Java内存模型对volatile专门定义了一些特殊的访问规则，主要包括两个特性：可见性和禁止指令重排序优化。

## **可见性**

**可见性是指，当一个变量被定义为volatile后，如果有一条线程对这个变量进行了修改，新值对于其他线程是立即可见的。**

关于volatile变量的可见性，经常会被开发人员误解。看看下面这段论述：

***"volatile变量对于所有的线程是立即可见的，对volatile变量所有的写操作都能立刻反应到其他线程之中，换句话说，volatile变量在各个线程中时一致的，所以基于volatile变量的运算在并发下是安全的。"***

这句话的论据并没有错，但是并不能得出“基于volatle变量的运算在并发下是安全的”这个结论。因为Java里面的运算并非是原子的，导致volatile变量的运算在并发下一样是不安全的，可以通过一段简单的示例来说明，代码清单如下：

{% highlight java %}
// volatile变量自增运算测试
public class VolatileTest {
    public static volatile int race = 0;

    public static void increase() {
        race++;
    }

    private static final int THREADS_COUNT = 20;

    public static void main(String[] args) {
        Thread[] threads = new Thread[THREADS_COUNT];
        for (int i = 0; i < THREADS_COUNT; i++) {
            threads[i] = new Thread(new Runnable() {
                @Override
                public void run() {
                for (int i = 0; i < 10000; i++) {
                    increase();
                    }
                }
            });

            threads[i].start();
        }

        // 等待所有累加线程都结束
        while (Thread.activeCount() > 1)
            Thread.yield();

        System.out.println(race);
    }
}
{% endhighlight %}

这段代码发起了20个线程，每个线程对race变量进行了10000次自增操作，如果这段代码能够正确并发的话，最后输出的结果应该是200000，然而真实的结果并非如此，而且每次运行的结果也都不一样，这是为什么呢？

问题出在自增运算“race＋＋”中，通过将这段代码Javap反编译后，发现increase()方法在Class文件中是由4条字节码指令构成的，并不是原子的操作。

{% highlight java %}
public static void increase();
    Code:
         Stack=2, Locals=0, Args_size=0
         0: getstatic #13; //Field race:I
         3: iconst_1
         4: iadd
         5: putstatic #13; //Field race:I
         8: return
     LineNumberTable:
         line 14: 0
         line 15: 8
{% endhighlight %}

由于volatile只能保证可见性，在不符合以下两条规则的运算场景中，我们仍然要通过加锁来保证原子性。

* 运算结果并不依赖变量的当前值，或者能够确保只有单一的线程修改变量的值；
* 变量不需要与其他状态变量共同参与不变约束。

下面的代码展示了volatile的使用场景，用作线程见的信号传递，当shutdown()方法调用时，能保证所有线程中执行的doWork()方法都立即停下来。

{% highlight java %}
volatile boolean shutdownRequested;

public void shutDown(){
    shutdownRequested = true;
}

public void doWork(){
    while(!shutdownRequested){
    // do stuff
    }
}
{% endhighlight %}

## **禁止指令重排序**

使用volatile变量的第二个语义是禁止指令重排序优化。

普通的变量仅仅会保证在该方法的执行过程中，所有依赖赋值结果的地方都能获取到正确的结果，而不能保证变量的赋值操作的顺序与程序代码的执行顺序一致。因为在一个线程的方法执行过程中无法感知到这点，这也就是Java内存模型中描述的所谓“线程内串行语义”。

通过一个例子来看看为什么指令重排序会干扰程序的并发执行，代码清单如下：

{% highlight java %}
Map configOptions;
char[] configText;
// 此变量必须定义为volatile
volatile boolean initialized = false;

// 假设以下代码在线程A中执行
// 模拟读取配置信息，当读取完成后将initliazed设置为true
configOptions = new HashMap();
configText = readConfigFile(fileName);
processConfigOptions(configText, configOptions);
initialized = true;

// 假设以下代码在线程B中执行
// 等待initialized为true，代表线程A已经把配置信息初始化完成
while(!initialized){
    sleep();
}

// 使用线程A中初始化好的配置信息
doSomethingWithConfig();
{% endhighlight %}

上述代码的描绘的场景十分常见。如果定义initialized变量时没有使用volatile修饰，就有可能因为指令重排序的优化，使得位于线程A中的最后一条语句“initalized = true”提前执行，这样在线程B中使用配置信息的代码就可能出现错误，而volatile关键字则可以避免此类情况的发生。

指令重排序是并发编程中最容易让开发人员产生疑惑的地方，下面的这段代码将分析volatile关键字是如何禁止指令重排序优化的。代码清单是一段标准的DCL单例模式，可以观察加入volatile和未加入volatile关键字时所产生汇编代码的区别。

{% highlight java %}
public class Singleton{
    private volatile static Singleton instance;

    private Singleton(){
    }
    
    public static Singleton getInstance(){
        if(instance == null){
            synchronized(Singleton.class){
                if(instance == null){
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
    
    public static void main(String[] args){
        Singleton.getInstance();
    }
}
{% endhighlight %}

编译后，这段代码对instance变量赋值部分如下代码清单所示：

{% highlight java %}
0x01a3de0f: mov $0x3375cdb0,%esi      ;...beb0cd75 33
                                      ; {oop('Singleton')}
0x01a3de14: mov %eax,0x150(%esi)      ;...89865001 0000
0x01a3de1a: shr $0x9,%esi             ;...c1ee09
0x01a3de1d: movb $0x0,0x1104800(%esi) ;...c6860048 100100
0x01a3de24: lock addl $0x0,(%esp)     ;...f0830424 00
                                      ;*putstatic instance
                                      ; -
Singleton::getInstance@24
{% endhighlight %}

通过对比就会发现，关键变化在于有volatile修饰的变量，赋值后（前面mov%eax，0x150（%esi）这句便是赋值操作）多执行了一个“lock addl＄0x0，（%esp）”操作，这个操作相当于一个内存屏障（Memory Barrier或Memory Fence)。

**内存屏障，是指重排序时不能把后面的指令重排序到内存屏障之前的位置。**

只有一个CPU访问内存时，并不需要内存屏障；但如果有两个或更多CPU访问同一块内存，且其中有一个在观测另一个，就需要内存屏障来保证一致性了。

那为何说它禁止指令重排序呢？

**从硬件架构上讲，指令重排序是指CPU采用了允许将多条指令不按程序规定的顺序分开发送给各相应电路单元处理。但并不是说指令任意重排，CPU需要能正确处理指令依赖情况以保障程序能得出正确的执行结果。**

譬如指令1把地址A中的值加10，指令2把地址A中的值乘以2，指令3把地址B中的值减去3，这时指令1和指令2是有依赖的，它们之间的顺序不能重排——（A + 10）* 2与A * 2 + 10显然不相等，但指令3可以重排到指令1、2之前或者中间，只要保证CPU执行后面依赖到A、B值的操作时能获取到正确的A和B值即可。所以在本内CPU中，重排序看起来依然是有序的。因此，lock addl＄0x0，（%esp）指令把修改同步到内存时，意味着所有之前的操作都已经执行完成，这样便形成了“指令重排序无法越过内存屏障”的效果。

## **volatile的意义**

它能让我们的代码比使用其他的同步工具更快吗？

在某些情况下，volatile的同步机制的性能确实要优于锁（使用synchronized关键字或java.util.concurrent包里面的锁），但是由于虚拟机对锁实行的许多消除和优化，使得我们很难量化地认为volatile就会比synchronized快多少。

如果让volatile自己与自己比较，那可以确定一个原则：volatile变量读操作的性能消耗与普通变量几乎没有什么差别，但是写操作则可能会慢一些，因为它需要在本地代码中插入许多内存屏障指令来保证处理器不发生乱序执行。

不过即便如此，大多数场景下volatile的总开销仍然要比锁低，我们在volatile与锁之中选择的唯一依据仅仅是volatile的语义能否满足使用场景的需求。
