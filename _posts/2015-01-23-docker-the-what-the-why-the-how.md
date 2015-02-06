---
author: Boguste
layout: post
title: "Docker: the what, the why, the how"
date: 2015-01-23 15:47:25 -0500
tags: docker deployment testing environment 
categories: cloud distributed-systems
thumbnail: https://c2.staticflickr.com/8/7336/14098888813_1047e39f08.jpg
---

[In a previous post]({% post_url 2015-01-16-terraform-dot-io-all-hail-infrastructure-as-code %}), I briefly threw in a few "buzzwords", namely Immutable Infrastructure and Docker. To start, Docker is more than just a new buzzword increasingly appearing on folks resumes. It is a tool built to solve a particular problem: the Immutable Infrastucture - also refered to as [Immutable Servers](http://martinfowler.com/bliki/ImmutableServer.html). The approach that it takes to achieve that is fairly different from automated configuration tools (ACL), and is one that has opened multiple possibilities for both devs and ops folks. 

<div class="small-quote post">
	<p>"Docker is a platform for developers and sysadmins to develop, ship, and run applications. Docker lets you quickly assemble applications from components and eliminates the friction that can come when shipping code. Docker lets you get your code tested and deployed into production as fast as possible."</p>
    <a href="https://www.docker.com/whatisdocker/">@Docker</a>          
</div>

#What is Docker?

Docker is a packaging tool and application runtime. With it you are able to assemble/package an image which you can then run in a container. 

In Docker parlance, an image is an immutable layer. You can think of them as the layered segment of a space rocket. Each parts sits on top of the other and depends on the previous one.

<img src="http://upload.wikimedia.org/wikipedia/commons/3/34/Srb_16.png" align="middle" alt="Sure took a while"/>

**@Wikipedia**


Likewise, each layer represent modifications to the filesystems building up to the final image, i.e. the one we intend to ship/run/distribute. For example, let's say this was our Dockerfile:

<script src="http://gist-it.appspot.com/github/kstaken/dockerfile-examples/blob/master/nodejs/Dockerfile"></script>

In the above file, the source image is ubuntu. Every command that would execute past the "FROM" line (excluding MAINTAINER) would result in a intermediary image all the way to the last command. The final image (the tip of our rocket) can be tagged and versioned so as to give a descriptive name.

{% highlight bash %}
docker build -t myUser/myImageName:latest -
{% endhighlight %}

The above command would result in the final image built to be tagged with the name of 'myUser/myImageName' and the version 'latest'. If I were to push it to docker hub, I could then refer to it from a seperate Dockerfile as the source/parent image (FROM). If I were to run it, docker would run the image in a container, i.e an isolated environment in which the built image would be executed assuming an ENTRYPOINT or CMD has been defined. 

{% highlight bash %}
docker run -d --name=some_name -t myUser/myImageName:latest
{% endhighlight %}

The container itself is like, well, a container. Let's say you had a band, and you put them in a container for whichever reason.

<img src="http://upload.wikimedia.org/wikipedia/commons/a/a6/The_Loud_Family_at_Hotel_Utah.jpg" align="middle" alt="The Loud Family" width="50%"/>

For them to play music, you may want to give them guitars, mics, and other necessary instruments. For you to listen to the music outside of the container walls and communicate with the players, you may want to expose some sort of communication channel. Then when you close the container and tell the band to play, they would be able to do so without interference, yet you would still be able to listen.

Likewise, with a docker container, you can pass it item needed by your environment by passing in environment variables vales(*NOTE*: You do have the option of defining environment variables in you Dockerfile). You can also choose to expose certain ports so as to communicate with the application within the container...although you do have the option to hook into the host's network configuration. Other than that your application would run isolated from its host and from other containers. And once the container starts running it is immutable in that you cannot change its configuration. you cannot update the image. The processes running inside can, as they have write access. From outside the container all we can do is attach to it, stop it, restart it or start it. You also have the ability to commit the internal state of the container into a different image.

#Usages

The most obvious use I would say is Automated Deployment. Instead baking AMIs, and instead of using Chef or Puppet to build up your server and to grab deploy the latest version of your software, you could build a docker image and tag to the appropriate version.

For example, let's say I was building a [Scalatra](http://www.scalatra.org/) application that made use of the [SBT Native Packager](http://www.scala-sbt.org/sbt-native-packager/). I could set things up so as to build a docker image after running my tests and running the package task ('universal:stage').

Here's a sample Dockerfile for the app:

{% highlight bash %}
FROM williamyeh/scala:2.11.2

ADD target/universal/stage /services

WORKDIR /services

RUN chmod +x /services/bin/yourproject

EXPOSE 8000
CMD []
ENTRYPOINT ["/services/bin/yourproject"]

{% endhighlight %}

Then on the server, you would just need to run it with the needed environment variables passed along, as well as the mapped port. That's it. Simple isn't it?

<div class="accordion-group">
                        <div class="accordion-heading accordionize">
            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordionArea" href="#twoArea">
            Need more?
            <span class="font-icon-arrow-simple-down"></span>
        </a>
        </div>
        <div id="twoArea" class="accordion-body collapse">
            <div class="accordion-inner">
               Please refer to <a href="http://47ron.in/blog/2015/01/16/terraform-dot-io-all-hail-infrastructure-as-code.html">this previous post</a> in which I discuss Terraform.io and give a snippet of how I do my deployment using both Terraform and Docker.
            </div>
        </div>
</div>

Another use case is setting up services that your application may rely upon like MongoDB, Rabbitmq, MySQL, Postgres and even Oracle. Please check out the [registry](https://registry.hub.docker.com/) for all that's publicly available.

Another use case is that of testing your application. As part of CI process you could build and run the image in a detached container with little difficulty, making it easier to run integration tests on your system from Hosted CI solutions like [CodeShip](https://codeship.com/) or [CircleCI](https://circleci.com/). At the time of this writing, CircleCI has added [Docker support](https://circleci.com/docs/docker), whereas I believe you have to install it with Codeship.

Another possiblie usage: building your own Continuous Integration Service. When using tools like TeamCity you have to make sure that any changes to yout environment gets reverted back and cleaned out. You also have to make sure not to run build configurations that could step on each other's toes. 
With Docker, you could in theory set things up such that at the start of every build, a Dockerfile is generated containing:

<ul>
<li>all the environment values desired by the user. These could be read from a ci.yml file</li>
<li>the base image to be used (e.g. 'williamyeh/scala:2.11.2'). Again read from a ci.yml file</li> 
<li>an 'ADD' statement grabbing the deployment ssh keys</li>
<li> a 'RUN' statement cloning the repository and a 'WORKDIR' statement setting the location of the repository as the working directory</li>
<li> a collection of 'RUN' statement matching the set of steps the user wants executed. These could also be read from a ci.yml file</li> 
</ul>

To track the progress of the build, continued invocation of docker logs command could be triggered once the container is running (at the time of this writing I do not believe there is a way to redirect the output from container outside of `docker log`).

If the user wants build artifacts to be retrieved, you could grab them from the container by running `docker cp`.

One more possibility: you can also use Docker to set up Dev environments. No more "it works on my environment and not on yours". Each dev would have the exact same environment (more or less).

<a href="https://imgflip.com/i/grfeh"><img src="https://i.imgflip.com/grfeh.jpg" title="made at imgflip.com"/></a>


<div class="alert fade in">
                    <a class="close" data-dismiss="alert" href="#">&times;</a>
                    <strong>Warning!</strong><p/> 

I do maintain that the best way to learn about Docker is to checkout the docs. Nevertheless, I hope this article would have helped in your understanding of what it is, what problem(s) it exists to solve, and how it can be leveraged.
                </div>

Docker is a pretty amazing tool. Please give it a try. You won't regret it.