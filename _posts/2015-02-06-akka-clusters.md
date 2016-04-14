---
author: Boguste
layout: post
title: "Akka clusters"
date: 2015-02-06 20:22:39 -0500
tags:
- akka
- cluster
- reactive
- reactive-systems
- reactive-design
categories: cloud distributed-systems architecture
thumbnail: http://upload.wikimedia.org/wikipedia/commons/6/6d/Akka_mountain.jpg
---

[Akka](http://akka.io/) has been around for quite some time now, making the life of the modern developer so much easier. For those unfamiliar with it, it is a toolkit for building highly concurrent and distributed systems. It relies heavily on the [Actor model](http://c2.com/cgi/wiki?ActorsModel) for concurrency (i.e actors as entity capable of asynchronously processing messages they receives from other actors in its system) and has capacities for distributing one's application. One of the most recent mechanism it provides to achieve the latter: [Akka clusters](http://doc.akka.io/docs/akka/snapshot/common/cluster.html). Why should you care?

# Vanilla Akka

Let's examine how one would normally use it vanilla style. Let's pretend you had a very basic application in which you needed to send messages to an actor that would then print it.

First, let's define the contract.

{% gist bhameyie/a4a022b3c070ec22f7d4 Messages.scala %}

Now our Actor.

{% gist bhameyie/a4a022b3c070ec22f7d4 PrinterDude.scala %}

And finally, let's glue it all together.

{% gist bhameyie/a4a022b3c070ec22f7d4 Main.scala %}

In this simple example, everything is local. I create my actor, keep the resulting ActorRef and communicate with it. The obvious pitfalls with this scenario are that:

1. The actor system limited to a single process, i.e it cannot communicate with external actor systems, thus no built-in high availability or scaling mechanism
2. The application is tightly coupled with the Actor, i.e. it needs to know about it and construct it

<div class="accordion-group">
  <div class="accordion-heading accordionize">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionArea" href="#oneArea">
          Why not use Routing?
          <span class="font-icon-arrow-simple-down"></span>
      </a>
  </div>
  <div id="oneArea" class="accordion-body collapse">
      <div class="accordion-inner">
          For point #1, you could use <a href="http://doc.akka.io/docs/akka/snapshot/scala/routing.html">Routing</a> to ease the pain....but that would not resolve the issue.
      </div>
  </div>
</div>


I know what you're thinking. "I could just use [Remoting](http://doc.akka.io/docs/akka/snapshot/scala/remoting.html)". Well...let's see.

# Akka Remoting

Let's pretend we have the exact same code for our contract, which would now live in a shared jar file. Let's pretend we have 2 application: a client and a server.

Here's the server code:

{% gist bhameyie/f2ab2d02bb2ec2b68d82 Server.scala %}

Pretty much the same as our previous sample, except we no longer are sending printit message to the actor ourselves.

Now let's look at the client.

{% gist bhameyie/f2ab2d02bb2ec2b68d82 Client.scala %}

The client no longer need to hold a reference to the **PrinterDude** actor, which can now live solely on the server.

From looking at this code however, there are some obvioud pitfalls:

1. The client now needs to know about the full path to the **PrinterDude** actor, thus leaking some of the server's logic to the client due to the hierarchical way [actor paths](http://doc.akka.io/docs/akka/snapshot/general/addressing.html) are determined
2. The client now need to know the address of the server whose actor system holds the **PrinterDude**, thus exposing itself to failures due the server going down for example.

You could deal with issue #2 by keeping track of the addresses of those servers in a database or by service discovery using a tool like [Consul](https://consul.io/)...but why go that route if a built-in solution exists.

# Akka Clustering

<img src="http://i.imgur.com/RAKMw1I.jpg" alt="Cluster" width="60%">

In this scenario, our **Server** code from the remoting sample would not change.

We would still need to hold a shared jar that would contain our shared contract, as well as our topics/communication channels.

{% gist bhameyie/6bb9d49ef0acec14ed81 Shared.scala %}

Our actor (PrinterDude) would remain mostly unchanged but for one *minor* addition.

{% gist bhameyie/6bb9d49ef0acec14ed81 PrinterDude.scala %}

It is now subscribing to the *printingChannel* through the [DistributedPubSubExtension](http://doc.akka.io/docs/akka/snapshot/contrib/distributed-pub-sub.html), meaning that any messages published/sent on that channel that matches the **PrintIt** type would be received by that actor.

Now here's the client code

{% gist bhameyie/6bb9d49ef0acec14ed81 Client.scala %}

It is no longer sending messages directly to a specific actor. Instead, it entrusts the mediator with the responsibility of forwarding that message to whomever is interested in receiving it, which in our case is the **PrinterDude**.

And finally the configuration that the client and server use.

{% gist bhameyie/6bb9d49ef0acec14ed81 application.conf %}

With this model, no more tight coupling or leakage. The code can be split up cleanly, and the **PrinterDude** and related services could be hosted on entirely seperate boxes without breaking the client. New nodes could be deployed on demand and join the cluster, thus achieving higher availability and potentially increasing the amount of messages the cluster can process. If that wasnt cool enough, you can use **routers** with your cluster.

## A few things to note

For clustering to work, the joining nodes need point(s) of contact to help them join the cluster. These points of contact are refered to as "seed nodes". It is recommended to have multiple seed-nodes for obvious reasons. The leader would then be responsible for joining the new member.

In a local deployment scenario, the application config listed above would have a different *clustering.node-port* for nodes other than the seed node. On a multi-machine deployment scenario, it's the *clustering.host* that would be different for nodes other than the seed node.

It is possible to monitor changes in the cluster by subscribing to its state events.

{% gist bhameyie/6bb9d49ef0acec14ed81 Listener.scala %}

One thing that I've found intersting with how Akka does clustering is their Gossip protocol, which provides a deterministic way of recognising the leader, hencewhy there is no leader election.

One issue that I have had with using Akka clusters is the [split brain syndrome](http://whatis.techtarget.com/definition/split-brain-syndrome) which can occur when you have auto downing enabled.

# Conclusion

Akka = awesome.
Akka + Clustering = awesomer.

Happy coding!
