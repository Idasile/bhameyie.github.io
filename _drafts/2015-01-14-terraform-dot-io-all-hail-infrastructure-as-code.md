---
author: Boguste
layout: post
title: "Terraform.io : all hail infrastructure as code"
date: 2015-01-14 06:40:00 -0500
tags: terraform docker immutable_infrastructure continuous_deployment automated_deployment
categories: cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Kirkuk_Infrastructure_Rebuild.jpg/640px-Kirkuk_Infrastructure_Rebuild.jpg
---

If you are familiar with the concept of Continuous Deployment championed by Eric Ries of the [Lean Startup](http://en.wikipedia.org/wiki/The_Lean_Startup) fame, as well the motivations behind [Immutable Infrastructure](http://blog.codeship.com/immutable-deployments/), you know how beneficial it is to pusrsue mechanisms enabling the fast and automated deployment/distribution of your application, the main ones being that it decreases the feedback loop one new features while removing setup/environment issue inherent with mutability in your environment.

There are plenty of utilities and framework to help us achieve that. Vagrant for example can be used to set up VMs. Obviously most cloud providers such as AWS, Azure, and DigitalOcean provide SDKs and APIs to let you automatically create VMs...but you would then need to build your own solution that would leverage them. Configuration Management tools like Ansible, Chef and Puppet can be leveraged to configure the newly created VMs.

When I was looking up how to do continuous deployment with immutable infrastructure to deploy a web application, I came to realize I needed a way to set up my entire infrastructure on the cloud at the push of a command. I needed their configuration to vary based on parameters that I would define so as to reduce my costs between my UAT environment (from my develop branch) and the Production one (from my master branch) [**GIT WORKFLOW reference**]. I also needed a way for some of the resources I would have to create, namely my load balancers, to know the ip addresses of those VM instances. That solution should also provide a way for me to destroy that entire infrastructure. For the deployment of application, I needed it not only be immutable, but to also give the necessary guarentees that it would work exactly as I would have tested it in my CI, and my UAT environment.

The solution that has worked for me: Terraform for setting up all my VMs and Docker to package my application.

<img src="http://cdn.meme.am/instances/500x/58154129.jpg" align="middle" alt="Sure took a while"/>

There's plenty of information available on Docker, so I will not discuss it at length in this post. The simplest explanation I can give you on this is that docker is way to package application in layered images that can be run in a container. Once started, the container is "immutable", i.e while you can change things on the VM it is running on (which would go against having Immutable Infrastructure), to my knowledge you cannot change or update the container itself. You can stop it, start it, restart it, attach to it, but you cannot change it...and that's a very good thing.


* What is terraform?
  - created by
  - purpose
  - sample use cases where it would be useful

* Not the be all end all
  - primary strength
  - not a resource configuration thing (though allows that capacity)

* Sample of a somewhat complicated terraform set up with aws
