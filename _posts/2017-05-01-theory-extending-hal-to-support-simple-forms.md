---
author: Boguste
layout: post
title: "Theory: Extending HAL to support simple forms"
date: 2017-05-01 07:38:14 -0400
tags:
- theory
- hal
- api
- idea
categories:  theory
thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg
---

[HAL](http://stateless.co/hal_specification.html) is a format created by [Mike Kelly](http://stateless.co/) used to make APIs more explorables.
It can also be used for automatically generating parts of the UI via its links.
But what if it could be pushed a bit further?

# Motivation

<a href="https://imgflip.com/i/1o7jjv"><img src="https://i.imgflip.com/1o7jjv.jpg" title="made at imgflip.com"/></a>

Most forms can be made generic in many Enterprise Applications (Web and Mobile).
Their inputs are usually simple.
They don't usually have much in terms of prettyness.
They are temporary holders of information that would eventually be sent over to the backend.
Therefore, if you have a way to describe what your form should look like, it should be possible render them generically on any client platform, be it Web or Mobile.

HAL already provides a way to incorporate some metadata within the resource being returned.

``` json
{
    "_links": {
        "self": { "href": "/orders" },
        "curies": [{ "name": "ea", "href": "http://example.com/docs/rels/{rel}", "templated": true }],
        "next": { "href": "/orders?page=2" },
        "ea:find": {
            "href": "/orders{?id}",
            "templated": true
        },
        "ea:admin": [{
            "href": "/admins/2",
            "title": "Fred"
        }, {
            "href": "/admins/5",
            "title": "Kate"
        }]
    },
    "currentlyProcessing": 14,
    "shippedToday": 20,
    "_embedded": {
        "ea:order": [{
            "_links": {
                "self": { "href": "/orders/123" },
                "ea:basket": { "href": "/baskets/98712" },
                "ea:customer": { "href": "/customers/7809" }
            },
            "total": 30.00,
            "currency": "USD",
            "status": "shipped"
        }, {
            "_links": {
                "self": { "href": "/orders/124" },
                "ea:basket": { "href": "/baskets/97213" },
                "ea:customer": { "href": "/customers/12369" }
            },
            "total": 20.00,
            "currency": "USD",
            "status": "processing"
        }]
    }
}
```

I believe it could be possible to extend it to incorporate metadata that could guide the implementation of a UI form.

``` json
{
  "firstName": "04c48da7-5b2d-4eb4-a93e-50a22979394b",
  "lastName": "99e7d915-471a-481c-8e13-57523af39cad",
  "age": 77,
  "description": "6b51e2fa-a1f9-47bf-8ac1-944a7e60bdd4",
  "_links": {
    "self.Save": [
      {
        "href": "/Example/SaveExample1",
        "kind": "Save",
        "name": "Save"
      }
    ]
  },
  "_presentable": {
    "fields": [
      {
        "restrictions": [
          "Required"
        ],
        "boundTo": "firstName",
        "editable": true,
        "name": "First Name"
      },
      {
        "restrictions": [
          "Required"
        ],
        "boundTo": "lastName",
        "editable": true,
        "name": "Last Name"
      },
      {
        "restrictions": [
          "Required"
        ],
        "boundTo": "description",
        "editable": true,
        "name": "Description"
      },
      {
        "restrictions": [
          "Optional"
        ],
        "boundTo": "age",
        "editable": false,
        "name": "Age"
      }
    ],
    "actionBoundTo": "self.Save"
  },
  "_metadata": {
    "objectName": "Example1",
    "description": "Example 1"
  }
}
```

The json above is a variant of HAL that includes 2 new properties: `_metadata` and `_presentable`.

The `_metadata` field could be used to provide additional info on the form.
In theory, it could even be used to infer the name of the javascript function to be called on form submit.

The `_presentable` field contains a description of the fields that can be presented as well as their input restrictions.
It also contains the name of the link/action that can be called to send the form to the backend.

Here's how it could be coded up in C#.

<script src="https://gist.github.com/bhameyie/d43043b553576259de4b4f19705bb77f.js"></script>

And here's how it could be rendered in Javascript.

<script src="https://gist.github.com/bhameyie/909e2c6c3977b6486ed5552eb19bbaa3.js"></script>

__NOTE__: _Turns out there was already such an extension to the format called [HAL-Forms](https://rwcbook.github.io/hal-forms/)_.

Based on a very basic test I did, this should work.
A refinement would be to better follow the HAL spec by keeping the actual resource in a `_embedded` property.

<a href="https://imgflip.com/i/1o7ktn"><img src="https://i.imgflip.com/1o7ktn.jpg" title="made at imgflip.com"/></a>

While this has the potential to work, it could be interpreted as trying to make things [too generic](http://thrivesearch.com/three-flaws-in-software-design-part-3-being-too-generic/).
Plus, it can be argued that this would lead to coupling the presentation layer to the API layer.

Just an idea.