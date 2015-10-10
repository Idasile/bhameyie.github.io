---
author: Boguste
layout: post
title: "The rise of reactive systems: why?"
date: 2015-01-28 7:14:45 -0500
tags: reactive reactive-systems reactive-design design architecture
categories: distributed-systems architecture
thumbnail: https://c1.staticflickr.com/3/2633/3853784154_d6df0bb3e5.jpg
---

Most avid Twitter users remember the fail whale of the 2010 World Cup that almost sank Twitter before it could truly become the juggernaut that it is today. The root cause of it was that their system was being overloaded with requests, having found overnight fame during that international events. Being unable to service all of them at the time due to the architecture of their system, a lot of us trying to tweet "GOOOOAAALLL!!!" were greeted with the whale. That could have sunk their business as folks could have simply reverted back to using Facebook. Thankfully for them (and us), they survived and [lived to tell the tale](https://gigaom.com/2014/06/18/twitters-infrastructure-is-designed-to-keep-away-the-fail-whale/). What does that have to do with Reactive Systems?

The short answer: **everything**.

**@Copyright David Pilcher**

<img class="image" src="http://theart.name/uploads/posts/2010-08/1282684592_twitter_fail_whale_wallpaper_by_shannabanan_o_rama.png" alt="Twitter Fail Whale" width="70%">

Many other startups have succumbed under the weight of overnight success as their systems were not designed to scale. The immediate consequence was that their website/services became unresponsive, causing even the most patient users to take their business elsewhere. Reactive design helps prevent that.

At its core, a reactive approach aims to resolve responsiveness issues. As stated in the [Reactive Manifesto](http://www.reactivemanifesto.org/), Reactive Systems are meant to be **Responsive** (the system must "react" to the user input/action in a timely manner), **Resilient** (the system should be fault tolerant), **Elastic** (the system should be able to scale itself in proportion to its load), and **Message Driven** (the system should rely on non-blocking message passing mechanisms).

All of the final 3 main aspects of Reactive Systems help reinforce the first: they each ensure that your system is able to react as soon as possible to user inputs irregardless of load or failures encountered during processing.

For example, by ensuring your system is able to tolerate failures - and we know that failures **will** occur as stated by [Murphy's Law](http://en.wikipedia.org/wiki/Murphy%27s_law) - you are guarenteeing some form of response back to the client.

By adopting strategies for elasticity (e.g. automated deployment of additional nodes to support your system, dynamically creating new Actors or Message Handlers), you are guarenteeing that the user would still get serviced even when the system is under high load. Naturally you would want a cost efficient solution so as not to bankrupt your business.

Finally, using non-blocking communication removes synchronous waits and makes it easy to decouple your system, allowing you to deploy components seperately. This is also useful when your business grows as those sets of components could live in seperate repositories assigned to different teams (see this [Udi Dahan post](http://www.udidahan.com/2014/03/31/on-that-microservices-thing/) and this [Spotify article](https://ucvox.files.wordpress.com/2012/11/113617905-scaling-agile-spotify-11.pdf)).

In short: less whales, more smiles.

<a href="https://imgflip.com/i/gwn2o"><img class="image" src="https://i.imgflip.com/gwn2o.jpg" title="made at imgflip.com"/></a>

Hopefully this is enough to at least get you interested to find out more. If you're curious, more information can also be obtained from Roland Kuhn's upcoming book on [reactive design](http://manning.com/kuhn/) and Vaugh Vernon's [Reactive Enterprise](https://www.safaribooksonline.com/library/view/reactive-enterprise-with/9780133846904/) book.

While reactive design is not a silver bullet, it certainly is a significant step the right direction.
