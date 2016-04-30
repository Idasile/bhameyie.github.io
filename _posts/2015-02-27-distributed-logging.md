---
author: Boguste
layout: post
title: "Distributed logging"
date: 2015-02-27 15:11:34 -0500
tags:
- distributed
- distributed-systems
- distributed-logging
- centralized-logs
categories: cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/9/93/Stacked_logs_-_geograph.org.uk_-_285052.jpg
comments: true
---


Distributed systems are great! Loosely coupled components. Seperation of concern. Scalability. Awesome!...until something goes wrong and you have to debug the issue.

Let's say that you have split your application into multiple logical services located on different machines and that, as part of a given workflow, one service A needs to communicate with service B which needs to touch its database then talk to an external system then send a message to service C. Let's also pretend that you have a load balancer in front of 2 instances of service B, and that you have a machine for your PostgreSql database and a seperate one for RabbitMQ server.

Under most circumstances, your workflow seems to hold. But under circumstances you are yet to determine, it fails. What do you do?

If you had not put in place a mechanism to log errors and info into a central location...well...let's hope you can reschedule your dinner plans. You would essentially have to collect the logs from all of your servers to trace the issue. It's tedious, but it can be done. You would just have lose spend a lot of time combing through the logs....everytime you find issues in your system. Not a very good option isn't it? Besides, what if the problem was not solely due to a bug. What if someone had been trying to bruteforce into your machine? What if some other process in that server had been doing some funky stuff? More logs to analyze. Yay!!!

<img src="http://cdn.meme.am/instances/500x/59690248.jpg" alt="Log well" width="70%">

This why distributed logging (also known as centralized logs) [is critical](http://engineering.linkedin.com/distributed-systems/log-what-every-software-engineer-should-know-about-real-time-datas-unifying). For example, let's say your were using a logging service like [Loggly](https://www.loggly.com/) or [Logentries](https://logentries.com/) (both support syslog forwarding). Instead of collecting the logs from the different machines, you could go to their websites and see them there.

If you want a more DIY approach, you can use [Logstash](http://logstash.net/), a log management utility with which you can collect the logs, parse them, and put them were you want. For example, you could have your application send the logs out using the log4j AmqpAppender, then configure the logstash agent to read its input using the rabbitmq input plugin, grok it, then put the result in your elasticsearch database. Then you could use Kibana to view and search them. If dealing with a legacy system that you can't modify that puts out a trace log, you could configure your logstash agent to read from specific files instead of rabbitmq.

<img src="http://cdn.meme.am/instances/500x/59688126.jpg" alt="Log well" width="70%">

When dealing with distributed systems, you need centralized logs. It will save you time, which will help you adress problems faster, which could in turn save you big bucks.
