---
author: Boguste
layout: post
title: "Cassandra vs MongoDB for a bootstrapped startup"
date: 2015-06-03 9:49:10 -0500
tags: database cassandra startup
categories: general cloud
thumbnail: http://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Cassandra_logo.svg/500px-Cassandra_logo.svg.png
---

The database. One of the most boring yet essential system ever design by mankind. Its sole purpose, serve as a place where we store the data used by our uber-awesome-oh-so-incredible™ application. So long as it is online, that we can store our data in it, and that we can retrieve it, we tend not to concern ourselves with it. As [stated](http://planetcassandra.org/blog/mongodb-this-is-not-the-database-you-are-looking-for/) by Patrick Fadin : "Is it scaling? Yep. Is it online? Yep. Boring". Getting to the point where you have a boring database would indeed be the dream. To get there however, the very first step is picking the right one based on your application.

## MongoDB

In my time scouring the web, I have come accross many recommendations, some of which I have followed when working on a side project. Back in 2013, MongoDB was still the rage. All the cool kids were using it. Why not after all? Who could resist the promise of dumping all your nested data in collection and retrieve it just as easily? Database schemas? Why use that when you can have a dynamic schema instead? Beside, it's all asynchronous and fault tolerant. Everything is awesome, right? right?


<img src="http://cdn.meme.am/instances/500x/59835196.jpg" alt="Log well" width="70%">

**Note to self**: don't believe every you read on the internet.

Well, not quite. Having played with MongoDB and having read the experiences of other (see [McFadin's](http://planetcassandra.org/blog/mongodb-this-is-not-the-database-you-are-looking-for/), [Mei's](http://www.sarahmei.com/blog/2013/11/11/why-you-should-never-use-mongodb/), [Emin's](http://hackingdistributed.com/2013/01/29/mongo-ft/) and [Morgan's](https://blog.compose.io/the-coming-of-the-mongodb-document-locks/) posts), I can attest that it is good and still improving database that is lacking in a few areas, the most important of which being concurrency and fault tolerance. Plus the idea that you can just dump nested data in there is not a great one. I understood early on that retrieving segments of that data or updating it atomically can be quite painful. Also, there is a cost to having a dynamic schema vs a static one.

To be fair, I love MongoDB. It was fairly easy to get started with it. It was awesome. The database was indeed boring...until the application's complexity and modeling need started to increase.

It can be quite difficult to model a social network using MongoDb. Let's take a naive example. Let's say you have a User class defined as below:

{% highlight scala %}

case class Friend(id:String, since:DateTime)
case class PotentialFriend(id:String)
case class RequestedFriendship(id:String, requestedOn:DateTime)
case class User(id:String, name:String, friends:List[Friend], friendshipToReview:List[PotentialFriend], requestedFriendships:List[RequestedFriendship])

{% endhighlight %}

A fairly simple model. What happens if user X requests the friendship of user Y? Add user X to the friendship to review list of user Y, *AND* add user Y to the requestedFriendships of user X. 2 spots needing to be added without transactions. Should user Y decide to accept user X's friendship? Once again 4 spots would need to be updated, i.e. remove the users from their respective requested friendships and friendship to review lists, and add each other into their respective friends list.

In an ACID world, the multiple updates would not have bothered me that much. If one update failed, the other would not take place. With MongoDB however, due its fault tolerance woes, it could happen that in between requests to the database, something goes awry (a subway passes over the datacenter where my mongodb server is located an momentarily causes a loss of connection), if my write concern is not 'Journaled', I can find myself in a state where it would be impossible for me to detect that a failure has occur, and thus wouldn't be able to "manually" reverse whatever changes I had made.

What if I wanted to find what the friends of my friends liked? What if I wanted to find what network of friends (i.e. my friend, their friends, the friends of their friends) liked? That is not something that you could easily do with MongoDB.

What I've MongoDB to be useful at is to store data with a minimal amount of nesting. It makes it easier to retrieve later. For more complex modeling, especially in the case of social networks, I have found Neo4J to be a much better choice. MongoDB for the writes. Neo4J for the reads or Elasticsearch if you need full text search capabilities.

Assuming you use a service like [Compose.io](https://www.compose.io/) to host, scale and back up your MongoDB instance's for you, your are looking at least 18$/month. If you need to add more databases to complement Mongo's shortcomings, using Neo4J in the cloud with a service like [GrapheneDb](http://www.graphenedb.com/pricing.html) will cost between 50$-400$/month, while Compose's ElasticSearch would cost you north of 45$ a month. Add what you need an multiply by 12 month and that's how much you need to set aside just for your database cost. You obviously could handle the hosting and scaling yourself to reduce that cost.

If you're bootstrapping your startup and have limited time, but some resources, I could see how you could build your application with MongoDB initially to get a proof of concept and get funding, or even to get an MVP to test the market and fail fast. However, you will find yourself having to migrate to a different database later so as to lessen the developement costs, and limit the risks of tech support calls from customers asking "where's my data?".

<img src="http://cdn.meme.am/instances/500x/59837724.jpg" alt="Log well" width="70%">

## Cassandra

There are plenty of alternatives to MongoDB. Some of the good choices out there range from the good 'ol PostgreSql to up and coming [RethinkDb](http://rethinkdb.com/), [Riak](http://basho.com/riak/) and [Cassandra](http://cassandra.apache.org/). 

My personal criteria for determining which database to use are:

* it should be easy for me to set up a cluster with it, i.e. easy to automate, easy to maintain
* it would easy for me to get started with it (docs, tutorials, good tooling)
* it should be fault tolerant
* it should be reasonably priced

Based on that, Cassandra jumps out to me as a better choice. It is highly available and easy to scale, and well documented. It is also supported as a backend storage mechanism for [Titan](https://github.com/thinkaurelius/titan), meaning that in my case I wouldn't need to rely on Neo4J, thus reducing expenses. The only drawback: its cost.

If you care about using Cassandra as a service, you could use [InstaClustr](https://www.instaclustr.com/pricing/) for a price range of 299$ to 404$ a month. Setting up the cluster yourself on aws with minimum of 3 m3.large machine would cost you about 300$ per month. That is more expensive than just MongoDB, less expensive than MongoDB with side databases.

In theory, for just an MVP, you could use a smaller ec2 instance at the cost of performance, then switch to recommended configurations once you've validated your idea. 

<a href="https://imgflip.com/i/ie72q"><img src="https://i.imgflip.com/ie72q.jpg" title="made at imgflip.com"/></a>

The database should be boring. It should at its best be tool that facilitates building your application, and just a place to dump and retrieve data at its worst. It can help your business grow. It can cause it to fail. Choose wisely.
