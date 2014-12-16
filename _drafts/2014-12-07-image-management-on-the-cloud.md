---
author: Boguste
layout: post
title: "Modern image management On the Cloud"
date: 2014-12-20 08:48:58 -0500
tags: swift ios cloudinary image-management
categories: mobile cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

When building social media apps or other systems that involve user generated content which include images (profile images, blog post images, etc...), it is not long until we get to the important question wether to build and manage our own image management system, or to rely on existing services to help us achive that purpose.

Building it ourselves requires an upfront cost of building and managing servers (hardware and software) to receive and service those images in a timely manner, but also has the hidden cost of maintaining those systems, and building a secure API to allow interaction with those resources. There are obvisouly many ways to approach this.

### Option 1 

*Expand*
cluster of server, with new ones created on demand. each new upload causes the image to be phisycally sent over to one of the servers, and would trigger the duplication of the image to servers in different regions. upon succesful upload, the server would fire an event to be used a service responsible for storing the locations of the files. upon a client api requesting a url for a given image id, the query service will lookup the servers on which that file has been replicated, pick the one under the least amount of load and build a url for the user to use. The query service could cache the said image or file in Redis, with an expiration time. If that image is frequently requested, the query service could refresh the expiration time on the key.

### Option 2

*Expand*
Mongodb and redis to the rescue. Use MongoDB's GridFS to store files (assuming of course that the files are big). the query service would be responsible for query mongodb to get the file back, and build a url for the client to retrieve it. it could use redis as outline in the previous option

## Option 3

whatever you can come up. There are many ways to solve this problem.

While a DIY approach gives us some level of flexibility seeing as the solution would be exactly suited to our need, it could divert our efforts away from the core features needed by our application. Using Domain Driven Design terms (DDD), Image Management is a generic subdomain. If you can build it yourself, have it be secure, performant and whatnot in a minimal amount of time so as to not distract you too long from features tied to your Core domain, then go ahead. If not, you might want to consider using one of the cloud services that are out there instead.

Amongst those services, the 2 most celebrated ones are AWS S3 and Cloudinary.

## <a name="awsS3">AWS S3</a>

## <a name="cloudinary">Cloudinary</a>

<img src="/assets/img/memes/cloudinary-imagemanagement-manipulation.jpg" align="middle" alt="Cloudinary"/>

As stated earlier, [Cloudinary](http://cloudinary.com/) is a Cloud-based Image Management service. You can upload images (and videos), download them, delete them. One thing that, to me, gives Cloudinary an edge over other services is the ability to manipulate pictures. Using their SDKs or their REST API, you can resize pictures, detect faces, and even apply image filters a la Instagram.

In a future post, I will showcase how to upload an image using Cloudinary's iOS SDK and Swift.

*LINK POST*

## <a name="final">In conclusion</a>

Write Conclusion



