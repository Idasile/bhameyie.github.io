---
layout: post
title: "Choosing a tech stack for your bootstrapped startup"
date: "2015-09-16"
tags: startup
categories: general
thumbnail: https://pixabay.com/static/uploads/photo/2012/11/28/10/48/samurai-67662_640.jpg
---

Programming languages. Tons of them have emerged over the years. Some decent great ones. Some decent ones. Some pretty awful ones as well. Most have strong points. All of have weak points. So, which one to choose.

So, what language should you choose? What should you do to determine which is most appropriate for your organization? This is especially when your funds are limited.

Often time I hear/read folks claiming that it doesn't matter. Just pick one and roll with it. Well...it does!

We often hear the expression "use the best tool for the job". To me Programming languages are more like weapons you can use to slash problems. Choosing the right Programming language is one very important decision that might have an impact on the future of your product and, by extension, your company. It will determine how quickly you can get to market, how quickly you can deliver updates and fixes, how easily you can field your engineering staff with Devs that can become productive quickly, as well as how quickly you can adopt new programming/architectural paradigms.

The choice of a programming language is only the first piece of the equation. 
A very important question to ask oneself once you pick the language is what libraries, frameworks and tools will be available for me that would help me build my stuff quicker?

In reality, what you are really doing when choosing a programming language is also picking a Technical Stack. For simplicity sake, I will refer to a technical stack as language + libraries + framework + tooling.

Sure with the advent of Docker and Microservices, you could theoretically use an assortment of programming languages. What you'll find however is that someone will have to support the software built on those different languages that used different stacks that produced different errors under similar circumstances. That's the reason why quite a few folks tend to have platform/infrastructure teams that consolidate the tech stacks that are used.

# The Tech Stack to Get Things Done (GTD)

What tech stack to choose? This is entirely dependent on the nature of your business. What a startup building embedded system would need is most likely going to be different from say a web startup.

Assuming you are building something relatively complex that involves distributed systems, you would likely need to be able produce internal services that can communicate amongst each other, some mechanism for persistence, ways to expose some of your services' functionality to the outside world for consumption by a website, a mobile application, or some other client. You likely would also want to be able to handle multiple requests concurrently and fast. You would probably want the language you pick to easily help you express the domain in which you are developing.

In order to increase the delivery speed of your software irregardless of the nature of your product, you would likely want the tech stack you pick to have tooling that makes your life easy. For example:
- tooling to run unit tests and acceptance tests
- a compiler that is smart and fast so you can quickly deliver functionality
- tooling to help you automate tasks associated with your project and build

Let's take a stab at doing this with an example project. Let's say that ConArtist Inc is developing a mobile app for artists to sell their imitation painting as well as original ones. Artists need to be able to post pictures of their painting, and folks who want would have to bid on them based on a bidding period specified by the artist. Users should be able to comment and review the painting. If the user likes an artist's work, he/she should be able to follow that person so as to be notified of their latest work. Users should be able to sign up using Facebook or Twitter, as well as by email.

From this description, there are several components and services that are required to build this. You need account management, profile management, payment, bidding, commenting, and review aggregation services just to name a few. Let's say you are the only tech cofounder. You've read on Best Practices, you believe in having systems broken down appropriately based on the Domain, you've read up on micro services, you've read up on the Lean Startup and the need to deliver quickly. You also believe the project has a large potential, and you want to grow your team.

From this description, you would likely want the services to be able to communicate amongst themselves internally. Assuming you are anticipating lots of traffic generating tons of data, may be you choose to store it in Cassandra as your primary database, and ElasticSearch for your read optimized data. Maybe you also decide that external communication into your system would happen over HTTP with JSON.

Based on that you need to have a stack that will:
* have good, fast and mature JSON libraries
* have libraries to interact with Cassandra and Elastic search
* have mature frameworks or libraries for building Rest APIs
* have tooling ...

What steps would you take to choose your tech stack?

Let's consider a few criterias.

# How familiar am I with the language?

Why does this matter? The more familiar you are with something, the fastest it "could" be for you to get started and ship your product.

That doesn't necessarily mean that you should always go with the language you know best. If you are a solid FORTRAN programmer, you may find it a while lot easier for you to start coding your big idea in FORTRAN. It saves you from having to learn a new language and tech stack. That doesn't necessarily make it the right choice. Support for Restful APIs, for connecting to high volume database (Cassandra, etc...) and ease of deployment could be an issue. Not to mention that I dont know many Devs who dream to work on a startup that uses FORTRAN (but I may very well be wrong).

For ConArtist's scenario, FORTRAN wouldn't be a good choice. If however you are familiar with a tech stack that provides you a lot of benefits like ease of deployment, easy concurrency, a plethora of mature framework, a striving community and plenty of potential hires, it could very well be the better choice to go with it.

### Tech Stack attributes to WIN:

Some questions to ask oneself: how easy to use are the tools and frameworks that I am choosing? Are they well maintained? How is the community around it? How well supported is the language? How hard quickly and easily will it be to evolve and maintain my system over time? How hard or easy would it be to ship artifacts (libraries/executables) on that stack? How expensive will it be to deploy those artifacts (e.g. what server requirements will be needed, etc..)? How quickly can I gain proficiency on the language? How quickly can other folks get up to speed on that language/tech stack?
- Community: How active and mature is the community supporting that language? How many other folks know that language/tech stack?
- Hiring: How much level of expertise (Junior/Mid/Senior level Engineer) would be required to gain proficiency on it?
- How familiar am I with the language?

Quite a few languages, especially on the JVM or in Pyhton, have libraries that

How fast is the compilation of projects?

# Deployment

Here's a crazier scenario:
- Smith et al. release a new social media platform for the enterprise after a year of beta that has seen some of the big boys buy in. Six months after the well publicized release, some black hat hacker has managed to find a problem in the system could give him access to all the accounts and payment information of the users. The cocky hacker demands you pay him up in the next 30 minutes or else!! Thankfully, your logging and monitoring tools have helped the Dev see a critical problem in the code that is VERYYYYYY easy to fix (as in 2 lines of code). Unfortunately, it takes a long time to compile the code as the compiler does not do incremental compilation. Worse, it takes a full 3 minutes for your app to load up (i'm looking at you otherwise perfect Clojure*). You have 10 servers running on multiple locations that would need to be updated. Even if we assume that you are using tools like docker and marathon to help with deploying things faster, the Math says: you won't make it. Logic says: let's just shutdown the system since this is a very critical problem (probably the right course of action). Legal says: the agreements signed by the big companies stated a guarantee of 99% uptime, a.k.a you would breach the contract, which would cost even more. Solution: hacker gets a fat check because you could not deploy fast.

Sure, this is an unlikely scenario. But you get my point. Assuming you follow good development practices and whatnot, you should want yout tech stack to not hinder your ability to release quickly. You need to be able to fix bugs and release new features quickly.

A more reasonable scenario:
- Smith et al. are building an enterprise solution that needs to be deployable on premise. The enterprise, especially large financial or business entities, tend to be very...strict in terms of what they are willing to have deployed on their premises. They typically have a process they want software vendors to adhere by, and what that is not the case but they really want/need your product they will require you to provide ongoing support. That may be good for business, but it can take you away from evolving your software. If you choose a stack for which deployment is easy or versatile (i.e. can generate a war file for example, or can be hosted on iis, etc..), you will make your life easier


* Clojure has the ability to hotswap live running code.
This is obviously very important. You preferably want to use a tech stack that makes it easy as this could sink your business quickly.


# Evolution and Maintenance

# Community support

# Pool of developers

# Ramp up time for new team members
