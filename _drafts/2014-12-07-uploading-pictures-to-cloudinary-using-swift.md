---
author: Boguste
layout: post
title: "Uploading pictures to cloudinary using Swift"
date: 2014-12-07 08:48:58 -0500
tags: swift, ios, cloudinary, image management
categories: mobile development, cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

Add Tl;TR link to code solution here as a nice button, and add a link to the stackoverflow answer i posted (http://stackoverflow.com/a/26748021)

A little background:

- Why Cloudinary
  - How image management is typically done
  - How Cloudinary eases image management

- Why Swift
  - what is it

What difficulty arises when trying to use cloudinary api with swift
  - Swift requires a bridge header file to use cloudinary
  - Cocoapods usage tend not to work well wit Swift

The solution:
  - Show how to create a new project that uses Swift (with pix)
  - Add the necessary controllers and ui stuff to pick or live capture an image (with pix and gists)
  - Add link to cloudinary setup instructions (https://github.com/cloudinary/cloudinary_ios#setup)
  - Show how to create and use a Bridge header (with pix)
  - Show how to add cloudinary on that bridge header file
  - Shoud how to use cloudinary to upload the image and to listen on its termination event


