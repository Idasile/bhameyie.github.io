---
author: Boguste
layout: post
title: "Uploading pictures using Cloudinary and Swift"
date: 2014-12-07 08:48:58 -0500
tags: swift ios cloudinary image-management
categories: mobile cloud
thumbnail: http://www.toptal.com/uploads/blog/category/logo/293/Apple_Swift_Logo.png
---

Let say we wanted to upload images captured through our iOS app to the cloud, and we have chosen Cloudinary as the means to this. Let say we have chosen to build application using [Swift](https://developer.apple.com/swift/), the new programming language released by Apple for building iOS applications.

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

          <a href="http://stackoverflow.com/a/26748021" class="button">Click here</a> to checkout out my stack overflow answer
      </div>
  </div>
</div>

You would think that we could just grab the Cloudinary SDK and get crackin right? right? right ?! Wrong!!

<img src="/assets/img/memes/objective-from-swift.jpg" align="middle" alt="Objectice-C and Swift"/>

As Swift is yet to get good tooling for dependency management (Cocoapods tend not to work), there's a few manual steps you have to perform. Let's get coding!

## <a name="solution"> Solution </a>

The code for this solution can be found on <a href="https://github.com/47ron-in/cloudinary-swift-template"><img src="https://octodex.github.com/images/octobiwan.jpg" alt="Github" width="42" height="42"/></a>

Let's pretend you have a RESTful service that returns you a list of items, whose properties include the URL of its associated image. 

First, let's add the ability to pick or capture the image to be uploaded.

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

