---
layout: post
title: "Choosing a tech stack for your bootstrapped startup"
date: "2015-10-11"
tags: startup
categories: general
thumbnail: /assets/images/posts/desk.jpg
---

Programming languages. Tons of them have emerged over the years. Some decent great ones. Some decent ones. Some pretty awful ones as well. Most have strong points. All of have weak points. Often time I hear/read folks claiming that it doesn't matter. Just pick one and roll with it. Well...it does!

<img src="http://cdn.meme.am/instances/57812573.jpg"  alt="Neo"/>

We often hear the expression "*use the best tool for the job*". To me Programming languages are more like weapons you can use to slash problems. Choosing the right Programming language is one very important decision that might have an impact on the future of your product and, by extension, your company. It will determine how quickly you can get to market, how quickly you can deliver updates and fixes, how easily you can field your engineering staff with developers that can become productive quickly, as well as how quickly you can adopt new programming/architectural paradigms.

The choice of a programming language is only the first piece of the equation. In reality, what you are really doing when choosing a programming language is also picking a Technical Stack. For simplicity sake, I will refer to a technical stack as language + libraries + framework + tooling.

Sure with the advent of Docker and Micro Services, you could theoretically use an assortment of programming languages. What you'll find however is that someone will have to support the software built on those different languages that used different stacks that produced different errors under similar circumstances. That's the reason why quite a few folks tend to have platform/infrastructure teams that consolidate the tech stacks that are used.

So, what language should you choose? What should you do to determine which is most appropriate for your organization? This is especially when your funds are limited.

# The Tech Stack to Get Things Done (GTD)
What tech stack to choose? This is entirely dependent on the nature of your business. What a startup building embedded system would need is most likely going to be different from say a web startup.

Assuming you are building something relatively complex that involves distributed systems, you would likely need to be able produce internal services that can communicate amongst each other, some mechanism for persistence, ways to expose some of your services' functionality to the outside world for consumption by a website, a mobile application, or some other client. You likely would also want to be able to handle multiple requests concurrently and fast. You would probably want the language you pick to easily help you express the domain in which you are developing.

Let's say that ConArtist Inc is developing a mobile app for artists to sell their imitation painting as well as original ones. Artists need to be able to post pictures of their painting, and folks who want would have to bid on them based on a bidding period specified by the artist. Users should be able to comment and review the painting. If the user likes an artist's work, he/she should be able to follow that person so as to be notified of their latest work. Users should be able to sign up using Facebook or Twitter, as well as by email.

From this description, there are several components and services that are required to build this. You need account management, profile management, payment, bidding, commenting, and review aggregation services just to name a few. Let's say you are the only tech cofounder. You've read on Best Practices, you believe in having systems broken down appropriately based on the Domain, you've read up on micro services, you've read up on the Lean Startup and the need to deliver quickly. You also believe the project has a large potential, and you want to grow your team.

From this description, you would likely want the services to be able to communicate amongst themselves internally. Assuming you are anticipating lots of traffic generating tons of data, may be you choose to store it in Cassandra as your primary database, and ElasticSearch for your read optimized data. Maybe you also decide that external communication into your system would happen over HTTP with JSON.

Based on that you need to have a stack that will:
* have good, fast and mature JSON libraries
* have libraries to interact with Cassandra and Elastic search
* have mature frameworks or libraries for building Rest APIs capable of handling request concurrently and fast

In order to increase the delivery speed of your software irregardless of the nature of your product, you would likely want the tech stack you pick to have tooling that makes your life easy. For example:
- tooling to run unit tests and acceptance tests
- a compiler that is smart and fast so you can quickly deliver functionality. It shouldn't take you hours to compile your project whenever you add a new feature
- tooling to help you automate tasks associated with your project and build

Some questions to ask oneself: how easy to use are the tools and frameworks that I am choosing? Are they well maintained? How is the community around it? How well supported is the language? How hard quickly and easily will it be to evolve and maintain my system over time? How hard or easy would it be to ship artifacts (libraries/executables) on that stack? How expensive will it be to deploy those artifacts (e.g. what server requirements will be needed, what RAM usage, etc..)? How quickly can I gain proficiency on the language? How quickly can other folks get up to speed on that language/tech stack? How active and mature is the community supporting that language? How many other folks know that language/tech stack?

# Why does all that matter?
If the tooling and framework you choose are hard to grasp in a relatively short time, that could potentially hinder the speed at which you will be able to implement new features, and will increase the time it would take a new hire to get up and running in your stack. Simple is boring and boring is good. It is easier to get good developers to learn a new programming language and tech stack that is easy to grasp.
To be fair, some stacks tech longer to grasp but with increased rewards. I find that to be true with ML languages like Haskell, Scala and F#. Unfortunately it presents a barrier of entry that limits the pool of developers you can hire to grow your team.

If the stack you choose is littered with poorly maintained libraries, including the ones you are thinking about using, you would be setting yourself up to do additional work to support those libraries you pick by yourself, or to build and maintain your own. When starting up, it is true that you often have more time than resources. But time itself is a precious commodity better invested in building up your startup vs providing a lot of support to external libraries or even re-inventing the wheel when you can help it.

The community around your tech stack is very important. It will determine the long lasting maintenance of the language and tools you use, as well as the assistance you can get with problems encountered when implementing features using that stack. For programming languages, it will also help you gauge how easy it would be to attract good talents.

## Deployment
Deployment of your solution is also very important. Docker and configuration management tools can reduce the amount of pain you would need to go through to deploy. Nevertheless, there will still be a cost associated with deploying a solution built on any stack. It can manifest itself by the size of the artifacts that would be deployed (be it binaries or the full source code), the Memory consumption, the OS restrictions (e.g. having to provision a windows server vs a cheaper ubuntu one to run your solution), the packages that must be pre-installed on the environment prior to running your solution, and also the time it takes for your solution to start.  

Here's a real-life inspired scenario:
- XYZ Inc. releases a new social media platform for the enterprise after a year of betas that has seen FORTUNE 500 companies sign up for the service. Six months after the well publicized release, some black hat hacker has managed to find a problem in the system could give him access to all the accounts and payment information of the users. The cocky hacker demands you pay him up in the next 30 minutes or else!! Thankfully, your logging and monitoring tools have helped the Dev see a critical problem in the code that is VERYYYYYY easy to fix (as in 2 lines of code). Unfortunately, it takes a long time to compile the code as the compiler does not do incremental compilation. Worse, it takes a full 3 minutes for your app to load up. You have 10 servers running on multiple locations that would need to be updated. Even if we assume that you are using tools like docker and marathon to help with deploying things faster, the Math says: you won't make it. Logic says: let's just shutdown the system since this is a very critical problem (probably the right course of action). Legal says: the agreements signed by the clients stated guarenteed a 99% uptime, a.k.a you would breach the contract, which would cost you even more.

Solution: hacker gets a fat check because you could not deploy fast.

Sure, this is an unlikely scenario. But you get my point. Even if you follow good development practices and whatnot, you should want your tech stack to not hinder your ability to release quickly. You need to be able to fix bugs and release new features quickly.

A more reasonable scenario:
- Smith et al. are building an enterprise solution that needs to be deployable on premise. The enterprise, especially large financial and business entities, tend to be very...strict in terms of what they are willing to have deployed on their premises. They typically have a process they want software vendors to adhere by, but when that is not the case and they really want/need your product they will require you to provide ongoing support. That may be good for business, but it can take you away from evolving your solution. If you choose a stack for which deployment is easy or versatile (i.e. can generate a war file for example, or can be hosted on iis, etc..), you will make your life easier.

# Familiar Fallacy
One more question you could ask yourself is How familiar you are with the tech stack you are considering. Why does this matter? The more familiar you are with something, the fastest it "could" be for you to get started and ship your product.

That doesn't necessarily mean that you should always go with the language you know best. If you are a solid FORTRAN programmer, you may find it a while lot easier for you to start coding your big idea in FORTRAN. It saves you from having to learn a new language and tech stack. That doesn't necessarily make it the right choice. Support for Restful APIs, for connecting to high volume database (Cassandra, etc...) and ease of deployment could be an issue. Not to mention that I dont know many developers who dream to work on a startup that uses FORTRAN (but I may very well be wrong).

For ConArtist's scenario, FORTRAN wouldn't be a good choice. If however you are familiar with a tech stack that provides you a lot of benefits like ease of deployment, easy concurrency, a plethora of mature framework, a striving community and plenty of potential hires, it could very well be the better choice to go with it.

In conclusion, like many other choices we make in life, the best choice depends on your particular circumstances. When starting up, emphasis should be on the delivery of a stable solution that can be quickly evolved. Personal biases and preferences need to be relegated so as to make a sound decision for your business. The better the choice, the easier the road ahead.
