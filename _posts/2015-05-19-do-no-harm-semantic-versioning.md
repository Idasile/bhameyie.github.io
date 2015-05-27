---
author: Boguste
layout: post
title: "Do No Harm: Semantic Versioning"
date: 2015-05-99 9:20:43 -0400
tags: best-practices general semantic-versioning versioning
categories: donoharm
thumbnail: http://pixabay.com/static/uploads/photo/2015/03/10/12/28/coffee-667052_640.jpg
---

Here's a little story inspired by true events. It's 7.30 PM on a Sunday. After weeks upon weeks of hard work, you are now one commit away from releasing the new uber-awesome-oh-so-incredible (TM) application that will revolutionize the entire world. You can already see the millions of happy faces with each keystroke as you are about to push your latest changes. But you decide to do your due diligence. A new bug fix for the library you've been using to connect to your datastore has been released. After reading the release notes, you realize they've fixed a pretty significant bug you were unaware of, so you decide to update. After all, it's just a bug fix. Nothing should break, right? right? Wrong!

<img src="https://cat7cat.files.wordpress.com/2011/07/funny-pictures-cat-moon.jpg" align="middle" alt="No worky"/>

As it turns out, even though you went from version 6.3.1 to version 6.3.5, your code no longer compiles. Breaking changes to the API have been introduced in the bug fix. But you're the resilient kind, so you decide to fix it. 1 hour later, all the tests are passing, you are ready to push to your Cloud CI service. Everything works locally and on another machine. You are done....or so you think...

It's 8.30 PM, you receive notification that the build is broken. Everything still works on your machine, yet the library for the secondary datastore you use for analytics no longer works on the CI. 

<img src="http://www.buildsonmymachine.com/images/Row2_2a.jpg" align="middle" alt="No worky"/>

You quadruple check the version to make sure that all your working environment have the same version of that library. You contact your Cloud CI support team to ask if anything has changed with the way they deploy the database. It has not. So what could it possibly be? 

Out of the desperation, you use virtualbox to create a VM on which to run your tests. They fail for the same reasons they did on the CI. The world stops making sense. After a bunch of failed attempt at fixing the problem, you decide to clear any potential caches you may have on your local environment. Lo and behold, the bug is reproduced. As it turns out, somebody updated the library you've been using (introducing a bug in the process) and published it to their hosted maven repository, but they did not increase the version.

It's 1 AM Monday morning, you've missed the release. This would not have happened had the maintainer of those public libraries had followed [Semantic Versioning](http://semver.org/) and proper package distribution practices.

This is the first of a series of post I hope to start publishing every now and then. Any comments and thoughts would be welcome.
