---
author: Boguste
layout: post
title: "Microservices isolation patterns: Rest and RPC"
date: 2017-04-27 20:55:08 -0400
tags: 
categories: 
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

In the [previous article]({% post_url 2017-04-27-microservices-isolation-patterns %}), we introduced a problem for us to solve using different isolation patterns for Microservices. The first one we'll consider is the traditional one: keeping the data seperate but communicating of HTTP/RPC.

# The features

Some of the desired feature we want to implement are as follows:

1. a Biker Karma needs to be recomputed whenever a user writes a comment and that the point varies based on whether or not the post being commented was that of a friend.
1. a Biker Karma needs to be recomputed whenever a user likes a Biky Post
1. users with a karma value less than -50 must receive an e-mail saying their account is temporarily disabled and are not allowed to post comments or bikies until an semi-automated of their activities is reviewed to detect fraud of ToS breaches.
1. users can limit comments on a Biky Post to their friends only. Users can make that selection globally on their account privacy settings and on a post by post basis.

# The approach

To implement #1, we could have the Comment Service call the Friendship service to determine if the user is a friend or not.
Based on the response we get, we could then pass on the info to some Karma Granter service that responsible for karma recomputation.
Alternatively, we could just call the Karma Granter and have it call the Friendship service itself.
Likewise, implementing #2 would just mean calling the Karma Granter from the Like Service. Beforehand however, they would need to call the Biky Post service to ascertain the existence of the Biky being commented upon or liked.

In conjunction with #1 and #2, implemeting #3 could mean that when the Karma Granter performs a computation that yields a score less than -50, it could send a "You got bad karma" email and call the Feature Access Service in the Account domain that would lock down the account.. The Feature Access Service would also call a ToS Breach Service to validate nothing fishy is going on.

As for #4, the Comment service would always need to call the Privacy Service to check whether privacy was globally defined as "Only Friends can comment on my posts". Depending on the anwers, it may directly call the Frienship service to see if the commenter is a friend, or would first need to the Biky Post service to see whether that privacy option was selected and then call the Friendship service based on the answer.

# The catch...

Lots and lots of calls to different services are required to implement each feature. This is fine in theory. After all, isn't this similar to making a method call? You could use [Swagger](http://swagger.io/) codegen to produce clients of those services that you could call as if they were methods. All is well........not!

Distributing your system makes it more likely to fail for all sorts of reason like network connectivity issues, concurrency flaws, service availability, etc. In fact, the one thing you can be certain of is that a failure will ensure. It is inevitable.
As many others who have been on the receiving end of [Murphy's law](http://www.murphys-laws.com/murphy/murphy-laws.html) a good many time, the one thing you learn is to find ways to anticipate them and establish recovery strategies. This where it gets a bit more complicated with HTTP/RPC.

Let's say that, for whatever reason, the Karma Granter Service is down. Since such an outage can occur, perhaps you will add some retry logic for your requests. If the outage takes more than a few seconds however, your comment service would have become unusable, sending back errors on every requestc.

What if the ToS Breach Service is down? The Comment Service will also become unusable since it relies on the Karma Granter Service which relies on the Feature Access Service which relies on the ToS Breach Service. One service that is malfunctioning would lead to multiple dependent services failing on every request, sometimes in surprising way as the dependency chain might not always be evident.

The [next article]({% post_url 2017-04-27-microservices-isolation-patterns-reactive %}) in this serie will discuss a different pattern that I find more manageable and less risky.