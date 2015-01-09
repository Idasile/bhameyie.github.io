---
author: Boguste
layout: post
title: "Uploading pictures using Cloudinary and Swift"
date: 2015-1-08 08:48:58 -0500
tags: swift ios cloudinary image-management
categories: mobile cloud
thumbnail: http://www.toptal.com/uploads/blog/category/logo/293/Apple_Swift_Logo.png
---

Let say we wanted to upload images captured through our iOS app to the cloud, and we have chosen Cloudinary as the means to this. Let say we have chosen to build application using [Swift](https://developer.apple.com/swift/), the new programming language released by Apple for building iOS applications.

You would think that we could just grab the Cloudinary SDK and get crackin right? right? right ?! Wrong!!

<img src="/assets/img/memes/objective-from-swift.jpg" align="middle" alt="Objectice-C and Swift"/>

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


As Swift is yet to get good tooling for dependency management (Cocoapods tend not to work), there's a few manual steps you have to perform. Let's get coding!

## <a name="solution"> Solution </a>

Let's pretend you have a RESTful service that returns you a list of items, whose properties include the URL of its associated image. 

Let's also pretend you already have the means to pick the desire image to be uploaded, either via a controller with an AlertController, or an intermediary page on which the user selects the image to be uploaded.

E.g. Using a controller with 2 button
<script src="https://gist.github.com/bhameyie/b96c3a24e6b3c149d833.js"></script>

Upon completing the steps indicated in the cloudinary [setup instructions](https://github.com/cloudinary/cloudinary_ios#setup), we can now add a Bridge header file and related wrapper classes written in oh so lovely Objective-C.

<script src="https://gist.github.com/bhameyie/5e8cde38256ef3411834.js"></script> 

<div class="accordion-group">
                        <div class="accordion-heading accordionize">
            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionArea" href="#twoArea">
            What's a Bridge Header file?
            <span class="font-icon-arrow-simple-down"></span>
        </a>
        </div>
        <div id="twoArea" class="accordion-body collapse">
            <div class="accordion-inner">
               The bridge header file allows to bridge Objective-C to your Swift code, i.e. it enables you to leverage code written in Objective-C from Swift. <a href="https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html"> Here's more info.</a>
            </div>
        </div>
</div>

Let's tie it up in Xcode.

<img src="/assets/img/posts/BridgingExample_cloudinary.png" align="middle" alt="Objectice-C and Swift"/>
   

And finally, the last pieces to make it all work: the actual uploading.

<script src="https://gist.github.com/bhameyie/55eb51b58e05d4096c95.js"></script>

Voila!

<div class="alert fade in">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <strong>Warning!</strong><p/> 


Please keep in mind that I am not using the most secure way of uploading the file using cloudinary since i am keeping the <strong>api_secret</strong> on the mobile device. It can be easily changed following the steps highlighted <a href="https://github.com/cloudinary/cloudinary_ios#safe-mobile-uploading">here</a>
                </div>


Happy coding!

