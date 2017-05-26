---
author: Boguste
layout: post
title: "Reports and Business Intelligence in a reactive system"
date: 2017-05-26 14:51:15 -0400
tags: 
- cloud
- distributed-systems
- microservice
- microservices
- best-practices
- do-no-harm
- reactive
- event-driven
categories: cloud distributed-systems architecture
thumbnail: https://static.pexels.com/photos/2438/nature-forest-waves-trees.jpg
---

In a [previous post]({% post_url 2017-05-26-reports-and-business-intelligence-in-a-reactive-system %}), I had advocated for isolating services all the way down to their data using an Event Driven Architecture. The one potential sticky point: how to deal with reporting on the data stored by those isolated data stores, or even run any sort of analysis on them.

In a traditional system architecture, there are 2 popular options for obtaining data that can be used for creating a report or for running BI tools. Typically, folks would either have a Data Warehouse process that relies on ETL processes to extract relevant data from different locations and dump it into its data marts. Another approach I've seen used is to directly query the data from the operational data stores when building reports or performing analysis (__note__: not advisable unless you can guarentee that large queries won't affect performance or user experience).

The problem with the latter option is that it does not respect boundaries at all. One can argue that it is fine for a reporting system not to worry about any boundaries since its scope is the entirety of the system...but that's a slippery slope. Adopting such an opinion might lead to more and more systems being deemed to have too broad a scope for them to respect data boundaries.

The same goes for the first option, assuming the extraction is done directly against the data store. To avoid directly querying your data stores, you could expose the bounded context's data via HTTP endpoints whose sole purpose would be to act as Data Hoses. You could even slap a GraphQL interface on them to make it easier for the ETL process to query the data it wants. While that would better preserve the data boundaries, it is slower than direct database access and it exposes you to the risk of not being able to query data when one of those data hose services goes down.

Thankfully, with an Event Driven Architecture, there is a 3rd way of accessing the data from the different services that still maintains the data boundaries without the risk of your reporting/analysis process being severly impacted by an external service being down.

Instead of having an ETL process that periodically queries data, you could instead have data ingestion services that would __subscribe to various events__ coming out of the different services, then immediately transform and load that data into your data marts. No need to schedule an ETL anymore, as the data populated in your data mart as you as a change has occured. It's just that simple. There are utilities such as Apache Spark that makes it relatively easy hook up to stream of data coming from Kafka for example, and perform whatever operation on them that you see fit.

Directly querying data held by external services is dangerous because it couples services together. If a team working on `Service A` was to make a change to the structure of tables it relies upon then the team working on `Reporting` (or any other service that relies on directly querying its data) would have to change their logic as well. By relying on events instead, the team working on `Service A` can do whatever they want to their data store - including changing it from a relational store to a graph database for example - all without impacting anybody else. The only time other services would be impacted is when a change occurs to the Event being published.

In my experience, there rarely is a good reason for directly querying the data of another Bounded Context. My advice for anyone reading: Please Do Not Harm, Don't do it.