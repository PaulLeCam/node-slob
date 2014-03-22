Slob
====

Slob is made of an utility MVC framework made of Backbone Models and Collections, and React components as Views, and a middleware to render them and send their data to the client as JS objects.

Installation
------------

`npm install slob`

Previous work
-------------

Slob is inspired by the Twitter enginnering blog article [Improving performance on twitter.com](http://engineering.twitter.com/2012/05/improving-performance-on-twittercom.html) regarding the need to be able to render content both client-side and server-side, and the Airbnb Nerd blog article [Our First Node.js App: Backbone on the Client and Server](http://nerds.airbnb.com/weve-launched-our-first-nodejs-app-to-product/) for ideas reagarding the implementation.

The Airbnb team realeased their [Rendr](https://github.com/airbnb/rendr) librairy, but I wanted something much simpler, as I only needed to render the HTML content of some views and pass along the corresponding data to the client app.

Work in progress
----------------

This code is still in very early development, it requires lots of testing and is not appropriate for production applications.

License
-------

MIT - See LICENSE file
