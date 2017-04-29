---
author: Boguste
layout: post
title: "Microservices isolation patterns"
date: 2017-04-27 20:54:40 -0400
tags: 
- cloud
- distributed-systems
- microservice
- microservices
- best-practices
- do-no-harm
- reactive
- rpc
categories: cloud distributed-systems
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

The Microservice architectural pattern has gained in notoriety since being formally coined in 2014. Many books and articles have been written on this subject, including in this blog. One topic however that can never be stressed enough with this pattern is the importance of ensuring proper isolation of services and their data both within and outside bounded contexts. In this series, we'll examine two ways of achieving this.

# A quick refresher

<img src="/images/blog/isolation-patterns/refresher-glass.jpg" alt="Refresher" width="70%">

Like i've stated [before]({% post_url 2015-10-23-haproxy-in-the-era-of-microservices %}), you can think of microservices as small and autonomous services or independent processes that work together within a [bounded context](http://martinfowler.com/bliki/BoundedContext.html), communicating with each other over lightweight transports like HTTP.

# The problem

Let's say we're building a social platform for Bike lovers to chat about bikes, wheels and whatever else they fancy.
Let's imagine as well that we've split the system into multiple services with HTTP endpoint:

- Identity Service
- Registration Service
- Privacy Preferences Service
- Comment Service
- Basic Profile Service
- Biky Posting Service
- Liking Service
- Friendship Service
- Karma Indicator Service

Let's also claim that alongside those different "Front-end services" we also have additional ones not directly accessible by consumers outside our internal network that do things like actually calculating a Biker Karma, monitoring breaches of Terms Of Service, etc...

<img src="/images/blog/isolation-patterns/svcs.png" alt="All the Services" width="70%">

Let's also assume you have your data defined in different isolated schemas/databases as such:

- Account data used by the Identity, Feature Access, Privacy Preferences and Registration services
- Profile data used by the Basic Profile and Identity Integration Services
- Like data used by the Liking Service
- Commenting data used by the Comment Service
- Biky Post data used by the Biky Posting Service
- Friendship data used by the Friendship Service
- Karma data used by the Karma service

Some of the desired feature we want to implement are as follows:

1. a Biker Karma needs to be recomputed whenever a user writes a comment and that the point varies based on whether or not the post being commented was that of a friend.
1. a Biker Karma needs to be recomputed whenever a user likes a Biky Post
1. users with a karma value less than -50 must receive an e-mail saying their account is temporarily disabled and are not allowed to post comments or bikies until an semi-automated of their activities is reviewed to detect fraud of ToS breaches.
1. users can limit comments on a Biky Post to their friends only. Users can make that selection globally on their account privacy settings and on a post by post basis.

How would we go about implementing them knowing that some of the information needed for each item is dispersed across bounded contexts?

[Let's explore the first pattern]({% post_url 2017-04-27-microservices-isolation-patterns-rest-and-rpc %})