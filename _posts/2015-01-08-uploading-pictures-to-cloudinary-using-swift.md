---
author: Boguste
layout: post
title: "Uploading pictures using Cloudinary and Swift"
date: 2015-01-08 08:48:58 -0500
tags: swift ios cloudinary image-management
categories: mobile cloud
thumbnail: http://www.toptal.com/uploads/blog/category/logo/293/Apple_Swift_Logo.png
---

Let say we wanted to upload images captured through our iOS app to the cloud, and we have chosen Cloudinary as the means to this. Let say we have chosen to build application using [Swift](https://developer.apple.com/swift/), the new programming language released by Apple for building iOS applications.

You would think that we could just grab the Cloudinary SDK and get crackin right? right? right ?! Wrong!!

<img class="image" src="/assets/images/memes/objective-from-swift.jpg" align="middle" alt="Objectice-C and Swift"/>

As Swift is yet to get good tooling for dependency management (Cocoapods tend not to work), there's a few manual steps you have to perform. Let's get coding!

## <a name="solution"> Solution </a>

Let's pretend you have a RESTful service that returns you a list of items, whose properties include the URL of its associated image.

Let's also pretend you already have the means to pick the desire image to be uploaded, either via a controller with an AlertController, or an intermediary page on which the user selects the image to be uploaded.

E.g. Using a controller with 2 button
<script src="https://gist.github.com/bhameyie/b96c3a24e6b3c149d833.js"></script>

Upon completing the steps indicated in the cloudinary [setup instructions](https://github.com/cloudinary/cloudinary_ios#setup), we can now add a Bridge header file and related wrapper classes written in oh so lovely Objective-C.

<script src="https://gist.github.com/bhameyie/5e8cde38256ef3411834.js"></script>

Let's tie it up in Xcode.

<img class="image" src="/assets/images/posts/BridgingExample_cloudinary.png" align="middle" alt="Objectice-C and Swift"/>

And finally, the last pieces to make it all work: the actual uploading.

<script src="https://gist.github.com/bhameyie/55eb51b58e05d4096c95.js"></script>

Voila!

*UPDATE 6/22/15: Removed adapter code*

Please keep in mind that I am not using the most secure way of uploading the file using cloudinary since i am keeping the <strong>api_secret</strong> on the mobile device. It can be easily changed following the steps highlighted <a href="https://github.com/cloudinary/cloudinary_ios#safe-mobile-uploading">here</a>

Happy coding!
