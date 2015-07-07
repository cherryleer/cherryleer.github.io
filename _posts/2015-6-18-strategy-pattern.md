---
layout: post
title: 读书笔记：设计模式之策略模式
description: 策略模式定义了一些列算法，并把这些算法分别封装起来，让它们之间可以相互替换，此模式让算法的变化独立于使用算法的客户。
tags: 后端
---

## **概念**
 
策略模式定义了一些列算法，并把这些算法分别封装起来，让它们之间可以相互替换，此模式让算法的变化独立于使用算法的客户。
 
<p class="picture"><img alt="" src="/assets/img/2015-6-18/strategy-pattern-uml.png"/></p>

## **组成**

* **抽象策略类**：定义了所有支持算法的公共接口，是策略模式的核心。通常由一个接口或者抽象类来实现；
* **具体策略类**：实现了抽策略法类定义的所有算法；
* **上下文类**：持有一个策略类的引用，最终给客户端调用。

## **应用场景**

* 多个类只区别在表现行为不同，可以使用策略模式，在运行时动态选择具体要执行的行为。
* 需要在不同情况下使用不同的策略，或者策略还可能在未来用其他方式实现。
* 对客户隐藏具体策略的实现细节，彼此完全独立。

## **优缺点**

### **优点**

* 策略模式提供了管理相关的算法族的办法。策略类的等级结构定义了一个算法或行为族。恰当使用继承可以把公共的代码转移到父类里面，从而避免重复的代码；
* 策略模式提供了可以替换继承关系的办法。继承可以处理多种算法或行为。如果不是用策略模式，那么使用算法或行为的环境类就可能会有一些子类，每一个子类提供一个不同的算法或行为。但是，这样一来算法或行为的使用者就和算法或行为本身混在一起。决定使用哪一种算法或采取哪一种行为的逻辑就和算法或行为的逻辑混合在一起，从而不可能再独立演化。继承使得动态改变算法或行为变得不可能；
* 使用策略模式可以避免使用多重条件转移语句。多重转移语句不易维护，它把采取哪一种算法或采取哪一种行为的逻辑与算法或行为的逻辑混合在一起，统统列在一个多重转移语句里面，比使用继承的办法还要原始和落后。

### **缺点**

* 客户端必须知道所有的策略类，并自行决定使用哪一个策略类。这就意味着客户端必须理解这些算法的区别，以便适时选择恰当的算法类。换言之，策略模式只适用于客户端知道所有的算法或行为的情况；
* 策略模式造成很多的策略类，每个具体策略类都会产生一个新类。有时候可以通过把依赖于环境的状态保存到客户端里面，而将策略类设计成可共享的，这样策略类实例可以被不同客户端使用。换言之，可以使用享元模式来减少对象的数量。

## **应用举例**

### **1. 策略类FlyBehavior及其两个实现类（FlyWithWings和FlyNoWay）**

{% highlight java %}
// 所有飞行行为都必须实现的接口。
public interface FlyBehavior{
    pulic void fly();
}
{% endhighlight %}

{% highlight java %}
// 飞行行为的实现，给会飞的鸭子用
public class FlyWithWings implements FlyBehavior{
    public void fly(){
        System.out.println("I'm flying!");
    )
}
{% endhighlight %}

{% highlight java %}
// 飞行行为的实现，给不会飞的鸭子用
public class FlyNoWay implements FlyBehavior{
    public void fly(){
        System.out.println("I can't fly!");
    )
}
{% endhighlight %}

### **2. 策略类QuackBehavior及其三个实现类（Quack、MuteQuack和Squeak）**

{% highlight java %}
public interface QuackBehavior{
    public void quack();
}
{% endhighlight %}

{% highlight java %}
public class Quack implements QuackBehavior{
    public void quack(){
        System.out.println("Quack");
    }
}
{% endhighlight %}

{% highlight java %}
public class MuteQuack implements QuackBehavior{
    public void quack(){
        System.out.println("Silence");
    }
}
{% endhighlight %}

{% highlight java %}
public class Squeak implements QuackBehavior{
    public void quack(){
        System.out.println("Squeak");
    }
}
{% endhighlight %}


### **3. 上下文Duck类**

{% highlight java %}
public abstract class Duck｛

    // 每只鸭子都会引用实现的FlyBehavior对象
    FlyBehavior flyBehavior;

    // 每只鸭子都会引用实现的QuackBehavior对象
    QuackBehavior quackBehavior;
    
    public abstract void display();
    
    public void performFly(){
        // 鸭子对象不亲自处理fly行为，而是委托给flyBehavior引用的对象 
        flyBehavior.fly();
    }
    
    public void performQuack(){
        // 鸭子对象不亲自处理quack行为，而是委托给quackBehavior引用的对象 
        quackBehavior.quack();
    }
    
    public void swim(){
        System.out.println("All ducks float, even decoys!");
    }
｝ 
{% endhighlight %}

### **4. 具体上下文实现MallardDuck类**

{% highlight java %}
public class MallardDuck extends Duck｛
    
    public MarllardDuck(){
        // 在构造函数中指定具体的策略
        quackBehavior = new Quack();
        flyBehavior = new FlyWithWings();
    }
    
    public void display(){
        System.out.println("I'm a real mallard duck!");
    }
｝ 
{% endhighlight %}

### **5. 测试类MiniDuckSimulator**

{% highlight java %}
public class MiniDuckSimulator{
    public static void main(String[] args){
        Duck mallard = new MallardDuck();
        
        // 这会调用MallardQuack继承来的performQuack()方法
        // 进而委托给QuackBehavior对象处理
        mallard.performQuack();
        mallard.performFly();
    }
}
{% endhighlight %}

### **6. 运行代码**

    %java MiniDuckSimulator
    
    Quack
    I'm flying!

## **动态设定行为**

### **1. 在Duck类中，加入两个新方法**

{% highlight java %}
public void setFlyBehavior(FlyBehavior fb){
    flyBehavior = fb;
}

public void setQuackBehavior(QuackBehavior qb){
    quackBehavior = qb;
}
{% endhighlight %}

### **2. 制造一个新的鸭子类型：模型鸭（ModelDuck）**

{% highlight java %}
public class ModelDuck extends Duck{
    public ModelDuck(){
        // 模型是不会飞的
        flyBehavior = new FlyNoWay();
        quackBehavior = new Quack();
    }
    
    public void display(){
        System.out.println("I'm a model duck");
    }
}
{% endhighlight %}

### **3. 建立一个新的FlyBehavior类型（FlyRockPowered）**

{% highlight java %}
public class FlyRockPowered implements FlyBehavior{
    // 一个新的飞行行为，用火箭飞行
    public void fly(){
        System.out.println("I'm flying with a rocket!");
    }
}
{% endhighlight %}

### **4. 改变测试类（MiniDuckSimulator），使用模型鸭，并使其用火箭飞行**

{% highlight java %}
public class MiniDuckSimulator{
    public static void main(String[] args){
        Duck model = new ModelDuck();
        // 第一次调用perform()会委托给flyBehavior对象，也就是FlyNoWay实例
        model.performFly();
        // 改变perform方法的flyBehavior对象，变成FlyRocketPowered实例
        model.setFlyBehavior(new FlyRocketPowered());
        // 第二次调用会委托给FlyRocketPowered实力
        model.perfomFly();        
    }
}
{% endhighlight %}

### **5. 运行代码**

    %java MiniDuckSimulator
    
    Quack
    I'm flying!
    I can't fly!
    I'm flying with a rocket!
    