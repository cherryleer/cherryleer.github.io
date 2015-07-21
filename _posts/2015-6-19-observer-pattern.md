---
layout: post
title: 读书笔记：设计模式之观察者模式
description: 观察者模式，也叫做发布－订阅模式，定义了对象之间的一对多依赖，这样一来，当一个对象改变状态时，它的所有依赖着都会收到通知并自动更新。
tags: 后端
---

## **概念**
 
观察者模式，也叫做发布－订阅模式，定义了对象之间的一对多依赖，这样一来，当一个对象改变状态时，它的所有依赖着都会收到通知并自动更新。
 
<p class="picture"><img alt="" src="/assets/img/2015-6-19/observer-pattern-uml.jpg"/></p>

## **组成**

* **主题接口**：对象使用此接口注册成为观察者，或者把自己从观察者中删除，每个主题可以有许多观察者；
* **具体主题类**：一个具体主题总是实现主体的接口，除了注册和撤销方法之外，具体主题还实现notifyObserver()方法，用于在主题状态改变时更新所有当前观察者；
* **观察者接口**：所有潜在的观察者必须实现观察者接口，这个接口只有update()一个方法，当主题状态改变时被调用；
* **具体观察者类**：具体观察者类可以是实现此接口的任意类。观察者必须注册具体主题，以便接收更新。

## **注意**

观察者模式有很多实现方式，从根本上说，该模式必须包含两个角色：主题和观察者。

实现观察者模式的时候要注意，主题和观察者对象之间的互动关系不能体现成类之间的直接调用，否则就将使主题和观察者对象之间紧密的耦合起来，从根本上违反面向对象的设计的原则。无论是观察者“观察”观察对象，还是主题将自己的改变“通知”观察者，都不应该直接调用。

## **应用举例**

假如你的团队刚刚赢得了一纸合约，负责建立Weather-O-Rama公司的下一代气象站－Internet气象观测站。

<p class="picture"><img alt="" src="/assets/img/2015-6-19/treaty.jpg"/></p>

### **气象监测应用的概况**

<p class="picture"><img alt="" src="/assets/img/2015-6-19/glimpse.jpg"/></p>

我们的工作就是建立一个应用，利用WeatherData对象取得数据，并更新三个布告板：目前状况、气象统计和天气预报。

### **设计气象站**

<p class="picture"><img alt="" src="/assets/img/2015-6-19/design.jpg"/></p>

### **实现气象站**

{% highlight java %}
public interface Subject{
    // 这两个方法都需要一个观察者作为变量，该观察者是用来注册或者删除的。
    public void registerObserver(Observer o);
    public void removeObserver(Observer o);
    
    // 当主题状态改变时，这个状态会被调用，以通知所有的观察者。
    public void notifyObservers();
}
{% endhighlight %}

{% highlight java %}
public interface Observer{
    // 所有观察者都必须实现update()方法，以实现观察者接口。
    public void update(float temp, float humidity, float pressure);
}
{% endhighlight %}

{% highlight java %}
public interface DisplayElement{
    // 只包含一个方法display()，当布告板需要显示时，调用此方法。
    public void display();
}
{% endhighlight %}

### **在WeatherData中实现主题接口**

{% highlight java %}
public class WeatherData implements Subject{
    // Arraylist用来记录观察者，稍后在构造器中建立。
    private ArrayList observers;
    private float temperature;
    private float humidity;
    private float pressure;
    
    private WeatherData(){
        observers = new ArrayList();
    }
    
    private void registerObserver(Observer o){
        observers.add(o);
    }
    
    private void removeObserver(Observer o){
        int i = observers.indexOf(o);
        if(i > 0){
            obervers.remove(i);
        }
    }
    
    // 当主题状态变更时，通知所有观察者
    public void notifyObservers(){
        for(int i = 0; i < observers.size(); i++){
            Observer observer = (Observer)observers.get(i);
            observer.update(temperature, humidity, pressure);
        }
    }
    
    public void measurementsChanged(){
        notifyObservers();
    }
    
    public void setMeasurements(float temperature, float humidity, float pressure){
        this.temperature = temperature;
        this.humidity = humidity;
        this.pressure = pressure;
        measurementsChanged();
    }
}
{% endhighlight %}

### **建立布告板**

{% highlight java %}
public class CurrentConditionsDisplay implements Observer, DisplayElement{
    private float temperature;
    private float humidity;
    private float pressure;
    private Subject weatherData;
    
    public CurrentConditionsDisplay(Subject weatherData){
        this.weatherData = weatherData;
        weatherData.registerObserver(this);
    }
    
    public void update(float temperature, float humidity, float pressure){
        this.temperature = temperature;
        this.humidity = humidity;
        this.pressure = pressure;
        display();
    }
    
    public void display(){
        System.out.println("Current conditions: " + temperature + "F degrees and " + humidity + "% humidity");
    }
}
{% endhighlight %}

### **启动气象站**

{% highlight java %}
public class WeatherStation{
    public static void main(String[] args){
        WeatherData weatherData = new WeatherData();
        
        // 建立布告板，并发weatherData对象传入
        CurrentConditionDisplay currentDisplay = new CurrentConditionDisplay(weatherData);
        
        weatherData.setMeasurements(80，65，30.4f);
        
        // 当主题状态更改时，会通知所有观察者更新数据
        weatherData.setMeasurements(70，55，20.4f);
    }
}
{% endhighlight %}

### **运行程序**

    %java WeatherStation
    Current conditions: 80.0F degrees and 65.0% humidity
    Current conditions: 70.0F degrees and 55.0% humidity
