---
author: Boguste
layout: post
title: "Modern image management: Uploading pictures using Swift"
date: 2014-12-07 08:48:58 -0500
tags: swift ios cloudinary image-management
categories: mobile cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

When building social media apps or other systems that involve user generated content which include images (profile images, blog post images, etc...), it is not long until we get to the important question wether to build and manage our own image management system, or to rely on existing services to help us achive that purpose.

<div class="accordion-group">
  <div class="accordion-heading accordionize">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionArea" href="#oneArea">
          TL;TR
          <span class="font-icon-arrow-simple-down"></span>
      </a>
  </div>
  <div id="oneArea" class="accordion-body collapse">
      <div class="accordion-inner">
      	  You can achieve that using Cloudinary's iOS SDK and a Bridge header file.<br/>

          To jump to the solution section on this post, <a href="#solution" class="button">click here</a>, or checkout out <a href="http://stackoverflow.com/a/26748021">my stack overflow answer</a>
      </div>
  </div>
</div>

Building it ourselves requires an upfront cost of building and managing servers (hardware and software) to receive and service those images in a timely manner, but also has the hidden cost of maintaining those systems, and building a secure API to allow interaction with those resources. 

While a DIY approach gives us some level of flexibility seeing as the solution would be exactly suited to our need, it could divert our efforts away from the core features needed by our application. Using Domain Driven Design terms (DDD), Image Management is a generic subdomain. If you can build it yourself, have it be secure, performant and whatnot in a minimal amount of time so as to not distract you too long from features tied to your Core domain, then go ahead. If not, you might want to consider using one of the cloud services that are out there instead. 

Amongst those services, the 2 most celebrated ones are AWS S3 and Cloudinary. As AWS S3 has been discussed to death, in this post I will solely focus on Cloudinary and how to use it in an iOS app.

## <a name="cloudinary">Cloudinary</a>

<img src="/assets/img/memes/cloudinary-imagemanagement-manipulation.jpg" align="middle" alt="Cloudinary"/>

As stated earlier, [Cloudinary](http://cloudinary.com/) is a Cloud-based Image Management service. You can upload images (and videos), download them, delete them. One thing that, to me, gives Cloudinary an edge over other services is the ability to manipulate pictures. Using their SDKs or their REST API, you can resize pictures, detect faces, and even apply image filters a la Instagram.

## <a href="scenario">Our scenario</a>

Let say we wanted to upload images captured through our iOS app to the cloud, and we have chosen Cloudinary as the means to this. Let say we have chosen to build application using [Swift](https://developer.apple.com/swift/), the new programming language released by Apple for building iOS applications.

You would think that we could just grab the Cloudinary SDK and get crackin right? right? right ?! Wrong!!

<img src="/assets/img/memes/objective-from-swift.jpg" align="middle" alt="Objectice-C and Swift"/>

As Swift is yet to get good tooling for dependency management (Cocoapods tend not to work), there's a few manual steps you have to perform. Let's get coding!

## <a name="solution"> Solution </a>

The code for this solution can be found on <a href="https://github.com/47ron-in/cloudinary-swift-template"><img src="https://octodex.github.com/images/octobiwan.jpg" alt="Github" width="42" height="42"/></a>

Let's pretend you have a RESTful service that returns you a list of items, whose properties include the URL of its associated image. 

First, let's add the ability to pick or capture the image the image to be uploaded.

FILL IN HERE how to write the code and link it using Xcode

Now, please follow the steps indicated in the cloudinar [setup instructions](https://github.com/cloudinary/cloudinary_ios#setup)

With that now, let's now add this Bridge header file. 

<div class="accordion-group">
                        <div class="accordion-heading accordionize">
            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionArea" href="#twoArea">
            What's a Bridge Header file?
            <span class="font-icon-arrow-simple-down"></span>
        </a>
        </div>
        <div id="twoArea" class="accordion-body collapse">
            <div class="accordion-inner">
               FILL IN
            </div>
        </div>
</div>

Let's tie it up in Xcode. FILL IN STEPS and a single picture

And finally, the last pieces to make it all work. FILL IN CODE to upload to cloudinary and wait for success.

<div class="alert fade in">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <strong>Warning!</strong><p/> 


Please keep in mind that I am not using the most secure way of uploading the file using cloudinary since i am keeping the <strong>api_secret</strong> on the mobile device. It can be easily changed following the steps highlighted <a href="https://github.com/cloudinary/cloudinary_ios#safe-mobile-uploading">here</a>
                </div>

That should do it!

Happy coding!

