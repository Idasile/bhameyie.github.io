---
author: Boguste
layout: post
title: "Microservices isolation patterns: Rest and RPC"
date: 2017-04-27 20:55:08 -0400
tags: 
- cloud
- distributed-systems
- microservice
- microservices
- best-practices
- do-no-harm
- rpc
categories: cloud distributed-systems
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

In the [previous article]({% post_url 2017-04-27-microservices-isolation-patterns %}), we introduced a problem for us to solve using different isolation patterns for Microservices. The first one we'll consider is the traditional one: keeping the data separate but communicating over HTTP/RPC.

<img src="/images/blog/isolation-patterns/svcs.png" alt="Refresher" width="70%">

# The features

Some of the desired feature we want to implement are as follows:

1. a Biker Karma needs to be recomputed whenever a user writes a comment. The karma score would vary based on whether or not the post being commented was that of a friend.
1. a Biker Karma needs to be recomputed whenever a user likes a Biky Post
1. users with a karma score less than -50 must receive an e-mail saying their account is temporarily disabled and are not allowed to post comments or bikies until a semi-automated validation of their activities is performed to ensure they did not breach the Terms of Service (ToS).
1. users can limit comments on their Bikies to their friends only. Users can make that selection globally on their account privacy settings or on a post by post basis.

# The approach

To implement #1 and #2, we could have the Comment Service and the Like Service call the Karma Granter service, which responsible for karma score re-computation. The Karma Granter would call the Friendship service itself to determine the new score.

In conjunction with #1 and #2, implementing #3 could mean that when the Karma Granter performs a computation that yields a score less than -50, it could send a "You got bad karma" email and call the Feature Access Service in the Account domain that would lock down the account.. The Feature Access Service would also call a ToS Breach Service to validate nothing fishy is going on.

As for #4, the Comment service would always need to call the Privacy Service to check whether privacy was globally defined as "Only Friends can comment on my posts". Depending on the answer, it may directly call the Friendship service to see if the commenter is a friend, or would first need to the Biky Post service to see whether that privacy option was selected and then call the Friendship service based on the answer.

Both the Comment Service and the Like Service might also need to call the Biky Post Service to ensure the post to be commented on or to be liked actually exists.

Here's an example of what it could look like.

<img src="/images/blog/isolation-patterns/rpc-example.jpg" alt="Refresher" width="70%">

# The catch...

Lots and lots of calls to different services are required to implement each feature. This is fine in theory. After all, isn't this similar to making a method call? You could use [Swagger](http://swagger.io/) code-gen to produce clients of those services that you could call as if they were methods. All is well........not!

Distributing your system makes it more likely to fail for all sorts of reason like network connectivity issues, concurrency flaws, service availability, etc. In fact, the one thing you can be certain of is that a failure __will__ happen. It is inevitable.
As one of many who have been on the receiving end of [Murphy's law](http://www.murphys-laws.com/murphy/murphy-laws.html), the one thing you learn is to do your best to discover what those failures might be and establish recovery and remediation strategies.

This where it gets a bit tricky with HTTP/RPC.

Let's say that, for whatever reason, the Karma Granter Service is down. Since such an outage can occur, perhaps you will add some retry logic for your requests with retry or time limit. If the outage takes more than a few seconds however, your comment service would have become unusable, sending back errors on every requests until you have remediated the situation.

What if the ToS Breach Service is down? The Comment Service will also become unusable since it relies on the Karma Granter Service, which relies on the Feature Access Service, which relies on the ToS Breach Service. One service that is malfunctioning would lead to multiple dependent services failing on every request, sometimes in surprising way as the dependency chain might not always be evident.

The [next article]({% post_url 2017-04-27-microservices-isolation-patterns-reactive %}) in this series will discuss a different pattern that I find more manageable and less risky.