---
layout: post
title: 设计模式笔记：装饰者模式
description: 装饰者模式，又叫装饰模式。装饰模式是在不必改变原类文件和使用继承的情况下，动态地扩展一个对象的功能。它是通过创建一个包装对象，也就是装饰来包裹真实的对象。
tags: 后端
---

## **概念**
 
装饰者模式，又叫装饰模式。装饰模式是在不必改变原类文件和使用继承的情况下，动态地扩展一个对象的功能。它是通过创建一个包装对象，也就是装饰来包裹真实的对象。
 
<img alt="" src="{{site.qiniu_static}}/assets/img/2015-7-8/decorator-pattern-uml.jpg"/>

## **组成**

* **组件接口**：给出一个抽象接口，以规范准备接收附加责任的对象；
* **具体组件类**：组件接口的具体实现，定义一个将要接收附加责任的类，装饰者类将动态扩展这个对象的功能；
* **装饰者接口**：持有一个组件对象的实例，并实现一个与抽象组件接口一致的接口，也可以是一个抽象类；
* **具体装饰者类**：装饰者接口的具体实现，用来给具体组件类动态扩展功能。

### **应用场景**

* 需要扩展一个类的功能，或者给一个类添加附加职责；
* 需要动态的给一个对象添加功能，这些功能可以再动态的撤销；
* 需要增加由一些基本功能的排列组合而产生的非常大量的功能，从而使继承关系变的不现实；
* 当不能采用生成子类的方法进行扩充时。一种情况是，可能有大量独立的扩展，为支持每一种组合将产生大量的子类，使得子类数目呈爆炸性增长；另一种情况可能是因为类定义被隐藏，或类定义不能用于生成子类。

## **优缺点**

### **优点**

* 装饰者模式与继承关系的目的都是要扩展对象的功能，但装饰者模式更灵活；
* 通过使用不同的具体装饰类以及这些装饰类的排列组合，可以创造出很多不同的行为组合。

### **缺点**

* 这种比继承更加灵活的特性，也同时意味着更加多的复杂性；
* 装饰者模式会导致设计中出现很多小类，如果过度使用，会使得很凌乱，可以结合工厂模式进行改善；

## **应用举例**

Starbuzz是以扩张速度最快而闻名的咖啡连锁店。因为扩张速度实在太快了，他们准备更新订单系统，以合乎他们对饮料供应要求。

他们原先的设计是这样的：

<img alt="" src="{{site.qiniu_static}}/assets/img/2015-7-8/pre-design.jpg"/>

购买咖啡时，也可以要求在其中加入各种调料，例如：豆浆、摩卡、牛奶或着奶泡。Starbuzz会根据所加入的调料收取不同的费用。

如果简单使用继承：

<img alt="" src="{{site.qiniu_static}}/assets/img/2015-7-8/simple-design.jpg"/>

### **使用装饰者模式**

<img alt="" src="{{site.qiniu_static}}/assets/img/2015-7-8/design.jpg"/>

<img alt="" src="{{site.qiniu_static}}/assets/img/2015-7-8/decorate-beverage.jpg"/>

### **Beverage抽象类**

{% highlight java %}
public abstract class Beverage{
    String description = "Unknown Beverage";
    
    public String getDescription(){
        return description;
    }
    
    // 所有子类都必须实现该方法
    public abstract double cost();

}
{% endhighlight %}

### **CondimentDecorator抽象类**

{% highlight java %}
public abstract class CondimentDecorator extends Beverage{
    // 所有调料装饰者都必须实现该方法
    public abstract String getDescription();
}
{% endhighlight %}

### **具体Beverage类**

下面创建了Espresso和HouseBlend两个示例，其余具体的Beverage也可以参照此方法实现，比如DarkRoast。

{% highlight java %}
public class Espresso extends Beverage{
    
    public Espresso(){
        despcription = "Espresso";
    }
    
    public double cost(){
        return 1.99;
    }
}

public class HouseBlend extends Beverage{
    
    public HouseBlend(){
        description = "HouseBlend";
    }
    
    public double cost(){
        return 0.89;
    }
}
{% endhighlight %}

### **具体CondimentDecorator类**

下面是Mocha示例，其余具体的CondimentDecorator也可以参照此方法实现，比如Whip和Soy。

{% highlight java %}
// Mocha是一个装饰者，所以继承自CondimentDecorator
public class Mocha extends CondimentDecorator{

    // 引用一个具体的Beverage类，用来表示被装饰者
    Beverage beverage;
    
    public Mocha(Beverage beverage){
        this.beverage = beverage;
    }
    
    // 为被装饰者装饰服务
    public String getDescription(){
        return beverage.getDescription() + ", Mocha";
    }
    
    // 要计算带Mocha的饮料价钱，首先把调用委托给被装饰对象，以计算价钱
    // 然后再加上Mocha的价钱，得到最后的结果
    public double cost(){
        return 0.20 + beverage.cost();
    }
}
{% endhighlight %}

### **供应咖啡**

{% highlight java %}
public class StarbuzzCoffee{

    public static void main(String[] args){
        // 订一杯Espresso，不需要调料
        Beverage beverage = new Espresso();
        System.out.println(beverage.getDescription() + " $" + beverage.cost());
        
        // 订一杯DarkRoast，加Whip和双倍Mocha的
        Beverage beverage2 = new DarkRoast();
        beverage2 = new Mocha(beverage2);
        bevearge2 = new Mocah(beverage2);
        beverage2 = new Whip(beverage2);
        System.out.println(beverage2.getDescription() + " $" + beverage2.cost());
        
        // 再来一杯HouseBlend，加Soy、Mocha和Whip
        Beverage beverage3 = new HouseBlend();
        beverage3 = new Soy(beverage3);
        bevearge3 = new Mocah(beverage3);
        beverage3 = new Whip(beverage3);
        System.out.println(beverage3.getDescription() + " $" + beverage3.cost());
    }
}
{% endhighlight %}

### **运行程序**

    %java Starbuzz
    
    Espresso $1.99
    Dark Roast Coffee, Mocha, Mocha, Whip $1.49
    House Blend Coffee, Soy, Mocha, Whip $1.34
