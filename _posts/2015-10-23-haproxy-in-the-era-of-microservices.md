---
author: Boguste
layout: post
title: "HAproxy in the era of Microservices"
date: 2015-10-23 12:27:46 -0400
tags: cloud microservices architecture mesosphere consul
categories: cloud architecture
thumbnail: https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/AWS_Simple_Icons_Networking_Amazon_Elastic_Load_Balancer.svg/768px-AWS_Simple_Icons_Networking_Amazon_Elastic_Load_Balancer.svg.png
---

*"Microservices"*, the latest architecture buzzword being thrown around to describe perhaps one of the most interesting architecture styles of this decade.

## What are microservices?

To use [Martin Fowler's definition](http://martinfowler.com/articles/microservices.html):

>In short, the microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API. These services are built around business capabilities and independently deployable by fully automated deployment machinery. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies

To simplify it further, you can think of microservices as small and autonomous services or independent processes that work together within a [bounded context](http://martinfowler.com/bliki/BoundedContext.html), communicating with each other over lightweight transports like HTTP.

How small is micro? As with everything, it depends. Some claim that a microservice should consist of a single actor. Others, like [Jon Eaves](http://techblog.realestate.com.au/micro-services-what-even-are-they/), claim it should be something you can complete in at most 2 weeks. I would think a general rule of thumb is that it should be small enough to be easily maintained by a small team (or a dev), and that it should focus on doing one thing and doing it very well.

The benefits of such an architecture are plentiful. For example, it makes it easier to adopt new technologies faster and to grow your team. It makes it easier to adopt the appropriate technology for solving a particular problem (e.g. you could have a microservice written in Scala and using Neo4j for storage, alongside another microservice written in Go and using Cassandra in the backend). It limits the risks of a complete system shutdown as most pieces are spread across a fleet of services across several machines. It makes it easier to scale on smaller machines, which can be huge cost saver.

Nevertheless, such an approach adds complexity in different areas, one of which is routing.

## Unified routing
<img class="image" src="https://upload.wikimedia.org/wikipedia/commons/7/78/Double_slip_at_Munich_central.jpg"  align="middle" height="300"/>

Assuming a relatively complex domain broken into multiple Bounded contexts, each of them can have 2 to N amount of microservices, each of them doing specific domain things. When scaling them, that number would grow even larger.

If you're trying to consume those services, you probably don't to want to keep track of them all. To go even further, if I'm writing a mobile application that needs to communicate with those many services, I don't want to have to maintain all the many addresses to those microservices. What would be better for me would be the ability to program against 1 base URL per bounded context (e.g. http://account.mystuff.com/api), and somehow have it figure out what microservices needs to be called based on a header.

This is where [HAproxy](http://www.HAproxy.org/) comes in.

<img class="image" src="http://cdn.meme.am/instances2/500x/2577680.jpg"/>

## HAproxy with microservices

As its name mentions, HAproxy is a high availability proxy server and load balancer that works both for TCP and HTTP. [More information](http://cbonte.github.io/haproxy-dconv/index.html) on it can be found in its docs.

Amongst its many features is the concept of an Access List (acl) that can be used to determine which backend to send a request to. The acl can be used to look at the header and the url, amongst other things.

To go back to our example of a mobile application wanting a single contact point, the request the dev could send over the wire could include a header (e.g "x-microservice-app-id") that HAproxy would then use to determine which endpoint to route to. *Note:* That contact point could itself be tied to [A record with multiple IP addresses pointing to load balancers](http://www.rightscale.com/blog/enterprise-cloud-strategies/dns-load-balancing-and-using-multiple-load-balancers-cloud) to avoid having a single point of failure.

Here's an example configuration on how to do so.

<script src="https://gist.github.com/bhameyie/07c1ee9aaa3e8a200c8c.js"></script>

The header names would be the one thing the client would have to maintain. Alternatively, if a convention was to be used, the header value would be computed, thus removing the need of the client to maintain the potentially numerous header names.

Following this approach would require you to be capable of syncing up your haproxy configuration with your deployment. There are various tools that can help such as [Marathon](https://mesosphere.github.io/marathon/) - which has utilities to produce haproxy configurations similar to the one in the above example, and [Kong](https://getkong.org/) - which is an API gateway.
