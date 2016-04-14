---
author: Boguste
layout: post
title: "Terraform.io : all hail infrastructure as code"
date: 2015-01-16 06:40:00 -0500
tags:
- terraform
- docker
- immutable
- infrastructure
- continuous
- deployment
- automated
categories: cloud distributed-systems
thumbnail: http://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Kirkuk_Infrastructure_Rebuild.jpg/640px-Kirkuk_Infrastructure_Rebuild.jpg
---

If you are familiar with the concept of Continuous Deployment championed by Eric Ries of the [Lean Startup](http://en.wikipedia.org/wiki/The_Lean_Startup) fame, as well the motivations behind [Immutable Infrastructure](http://blog.codeship.com/immutable-deployments/), you know how beneficial it is to pursue mechanisms enabling the fast and automated deployment/distribution of your application, the main ones being that the former decreases the feedback loop on new features while the latter removes setup/environment issues inherent with mutability in your environment.

There are plenty of utilities and frameworks to help us achieve that. Vagrant for example can be used to set up VMs. Obviously most cloud providers such as [AWS](http://aws.amazon.com/), [Azure](http://azure.microsoft.com/en-us/), and [DigitalOcean](https://www.digitalocean.com/) provide SDKs and APIs to let you automatically create VMs...but you would then need to build your own solution that would leverage them. Configuration Management tools like [Ansible](http://www.ansible.com/home), [Chef](https://www.chef.io/chef/) and [Puppet](http://puppetlabs.com/) can be leveraged to configure the newly created VMs.

When I was looking up how to do continuous deployment and build immutable infrastructure to deploy a web application, I came to realize I needed a way to set up my entire infrastructure on the cloud upon succesful completion of a CI build. I needed their configuration to vary based on parameters that I would define so as to reduce my costs between my UAT environment which would be built from my develop branch, and the Production environment which would be built from my master branch. I also needed a way for some of the resources I would have to create (namely my load balancers) to know the ip addresses of those VM instances. That solution should also provide a way for me to destroy that entire infrastructure. For the deployment of application, I needed it not only be immutable, but to also give me the necessary guarentees that it would work exactly as I would have tested it in my CI, and my UAT environment.

The solution that worked for me: [Terraform](https://terraform.io) for setting up all my VMs and [Docker](https://www.docker.com/) to package my application.

<img src="http://cdn.meme.am/instances/500x/58154129.jpg"  alt="Sure took a while"/>

There's plenty of information available on Docker, so I will not discuss it at length in this post. The simplest explanation I can give you on this is that docker is way to build application in layered images that can be run in a container. Once started, the container is "immutable", i.e while you can change things on the VM it is running on (which would go against having Immutable Infrastructure), to my knowledge you cannot change or update the container itself. You can stop it, start it, restart it, attach to it, but you cannot change it...and that's a very good thing.

Terraform.io is a utility written by the guys at Hashicorp (the company that built Vagreant). Its purpose is to provide means to code your infrastructure, set it all up and destroy it. It is built on [Go](https://golang.org/) yet has a rubyish feel to it. It enables the definition of variables and modules, and also comes bundled with quite a few provisioners for setting up resources on DigitalOcean and AWS to name a few. One of its greatest strength to me is the ability to reference resources and their properties in your terraform code. The output of terraform is also JSON parsable, which also opens up a host of possibilities.

One thing to keep in mind: Terraform is not meant to replace utilities like Chef or Puppet. Quite the contrary, you can still leverage them to configure your VM.

Say that like me you needed to setup your terraform environment upon succesfull completion of your build.

First, let's define our variables files.

<script src="https://gist.github.com/bhameyie/b46d46ef577e5f300196.js"></script>

Now let's create our module (*NOTE*: you don't need to have a module. I am including this nonetheless for teaching purposes)

<script src="https://gist.github.com/bhameyie/61889b8fe4b219e6cdce.js"></script>

The above file should be placed in a "app_servers" folder. Please note that I am using [CoreOS](https://coreos.com/) AMIs as they come prepackaged with Docker. Plus, they tend to take less time to boot up compared to Ubuntu AMIs.

And now, the final piece putting it all together.

<script src="https://gist.github.com/bhameyie/22688d3d6f1c4d2333bd.js"></script>

To run it:

<script src="https://gist.github.com/bhameyie/c3cecd65fe6179ab34a9.js"></script>

Simple isn't it? For my actual code, I have a ruby script that loads up the appropriate values in my terraform variables file based on whether I am deploying from develop vs master, and backs up the resulting terraform outputs to AWS S3 in a versioned folder and sends me a [HipChat](https://www.hipchat.com/) message to tell me whether or not it was all successful. This enables me to destroy prior versions of my infrastructure upon successful creation of the new version, and it also helps me downgrade versions more easily. The script also determines which VMs to create depending on my current branch. In production, as per my example, I use an ELB. I do not do that in UAT so as to reduce my costs.

Terraform is obviously not a silver bullet, but it is a great tool to have on your devops utility belt. As it continues to mature towards its in 1.0 release, I'm confident it will become even more awesome.
