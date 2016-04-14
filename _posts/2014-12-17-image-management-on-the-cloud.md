---
author: Boguste
layout: post
title: "Modern image management On the Cloud"
date: 2014-12-17 11:48:58
tags:
- aws
- s3
- cloudfront
- ec2
- cloudinary
- image-management
thumbnail: http://upload.wikimedia.org/wikipedia/commons/8/82/Img_51614_critical-data-centre-at-uni-of-hertfordshire.jpeg
---

When building social media apps or other systems that involve user generated content which include images (profile images, blog post images, etc...), it is not long until we get to the important question of wether to build and maintain our own image management system, or to rely on existing services to help us achieve that purpose.

Building it ourselves requires an upfront cost of building and managing servers (hardware and software) to receive and service those images in a timely manner, but it also has the hidden cost of maintaining those systems, and building a secure API to allow interaction with those resources.

If you absolutely must do it yourself, there are many ways to approach this.

# Option 1 : Storing images in the file system

Using your preferred cloud providers (e.g. AWS, DigitalOcean, SoftLayer, etc...), you could spin up a VM, preferably one that is optimized for storage like AWS EC2's I2 optimized storage, in which in you would store your images. You will need to set up monitoring tools to alert you when a server is reaching its capacity so as to automatically launch a new instance of the VM where subsequent images would be stored. That way you avoid the risk of having a single large server that would get hit repeatedly and which, if things went awry, could cause you to lose ALL of your images.

You will obviously need to back up those servers. One strategy would be to organize the servers into sets. What I mean by that is, for each server in one region - US East, US West, Europe, Asia - there should be at least one server in a separate region subscribing to the same MQ topic (or some other means of communication) such that, upon an image being uploaded, the recipient would fire an event to be received by other machines in its set so to make the image available in all the regions you care about. That way, whatever service querying the image would be able to pick the one hosted closest to caller of the service. Plus, should one of the server in the set be taken down, that image would still be retrievable in a seperate server, and even in a seperate region.

The metadata of the images - including their available location(s) - can be stored in a database.

You would need to have a query service(s), i.e. an endpoint (e.g. a RESTful service) that the client code could call to retrieve the URL to an image (with the associated metadata if it is needed) based on a file id. For optimization purposes, you'll want multiple instances of the query service running, possibly in different regions. The query service would look up the image location in the database, choosing one of the servers that is closest to the client, and build up the Url to the image.

With this approach, you'll have your mini Content Delivery Network (CDN).

# Option 2 : Storing images in a database

The alternative to hosting the files on the file system is to store them in a database. Quite a few databases come prebuilt with optimized options enabling the storage of files like Mongo's [Gridfs](http://docs.mongodb.org/manual/core/gridfs/). You could manage your database yourself, or leverage hosted options like [Compose](https://www.compose.io/).

With this approach, your query service could return the image directly from a MongoDB instance for example. For further optimization, you could make use of [Redis](http://redis.io/) to cache images that are frequently requested so as to not repeatedly hit the database.

# Option 3

Whatever you can come up. There are many ways to solve this problem.

One thing to keep in mind obviously is the cost of any solution. Not just in terms of resources, but also in terms of time, efforts and maintenance. The options I have listed above can be expanded or toned down to reduce the cost. For example, if you're a small shop and your target market is only in the US, you do not need to incur the cost of servicing multiple regions.

My take on this: if you are to store files, I would think you'd want them stored in the file system unless you need to maintain multiple versions of that file. Using the file system reduces the load on the database which, historically, are not designed specifically for storing files whereas file systems are. Also, storing large files in your database may increase your cost.

While a DIY approach gives us some level of flexibility seeing as the solution could be tailored to our need, it could divert our efforts away from the core features needed by our application. Using Domain Driven Design terms (DDD), Image Management is a generic subdomain. If you can build it yourself, have it be secure, performant and whatnot in a minimal amount of time so as to not distract you too long from features tied to your Core domain, then go ahead. If not, you might want to consider using one of the cloud services that are out there instead.

Amongst those services, the 2 most celebrated ones are [AWS S3](http://aws.amazon.com/s3/) and [Cloudinary](http://cloudinary.com/).

# AWS S3

AWS S3 has been discussed to death, so I wont go into much details about how it works and why its great.

Just to summarize:
<ul>
<li> it centered around the concept of buckets, which are virtual containers for your files and folders </li>
<li> access policies can be defined to control who can act upon resources stored in a bucket </li>
<li> buckets can be created in different regions in order to reduce latency and increase availability</li>
<li> version/history of the file in the bucket can be tracked</li>
</ul>
Programmatic access to AWS s3 is achievable using their SDKs which I have found to be pretty easy to use.

You could combine the use of AWS S3 with [AWS CloudFront](http://aws.amazon.com/cloudfront/), Amazon's CDN. You could actually use the latter with your file storage servers from option 1.

# Cloudinary

<img src="/assets/images/memes/cloudinary-imagemanagement-manipulation.jpg"  alt="Cloudinary"/>

As stated earlier, Cloudinary is a Cloud-based Image Management service. You can upload images (and videos), download them, delete them. One thing that, to me, gives Cloudinary an edge over other services is the ability to manipulate pictures. Using their SDKs or their REST API, you can resize pictures, detect faces, and even apply image filters a la Instagram.


Image management is made easy these days by a plethora tools and services. How you proceed depends largely on your requirement and the needs of your business. I hope this post will help you make the right call.
