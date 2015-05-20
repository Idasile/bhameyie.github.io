---
author: Boguste
layout: post
title: "Do No Harm: Semantic Versioning"
date: 2015-05-19 18:20:43 -0400
tags: best-practices general semantic-versioning versioning
categories: donoharm
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

It's 7.30 PM on a Sunday. After weeks upon weeks of hard work, you are now one checkin away from releasing the new uber-awesome-oh-so-incredible (TM) application that will revolutionize the entire world. You can already see the millions of happy faces with keystroke as you are about to push your latest changes. But you decide to do your due diligence. A new bug fix for the library you've been using to connect to your datastore has been released. After reading the release notes, you realize they've fixed a pretty significant bug you were unaware of, so you decide to update. After all, it's just a bug fix. Nothing break, right? right? Wrong.

[Image of guys saying why u break the build]

As it turns out, even though you went from version 6.3.1 to version 6.3.5, your code no longer compiles. Breaking changes have been introduced in the bug fix. But you're the resilient kind, so you decide to fix it. 1 hour later, all the tests are passing, you are ready to push to your Hosted CI service. Everything works locally and on another machine. You are done....or so you think...

It's 8.30 PM, you receive notification that the build is broken. (somebody replaced the jar file that was previously uploaded to the maven repository) 


This is the first of a series of post I hope to start publishing every now and then. Any comments and thoughts would be welcome.
