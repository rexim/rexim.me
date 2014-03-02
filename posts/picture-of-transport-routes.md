title: The Picture of City Routes
author: rexim
date: Fri, 28 Feb 2014 13:26:19 +0700
description: A post about one interesting task I was doing at my job.

I was participating in development of our local dictionary of
organizations with a city map like [2gis](http://2gis.com/). My last
task was probably the most interesting task for the whole year of
work. I was contributing to a part of our infrastructure intended for
searching the shortest paths on transport routes of a city.

Building a route graph from the database is an expensive operation, so
sometimes we cache it to a binary file. For a visual debug reason, I
created
[this little utility](https://github.com/rexim/routes-drawer). It
takes the binary file as an input, renders the graph, and dumps the
result to a PNG file. Here is an example:

![Rostov-on-Don](/images/rostov-on-don.png)

This is
[Rostov-on-Don](http://en.wikipedia.org/wiki/Rostov-on-Don). Red lines
are transport edges, green lines are walk edges. Here are some more
cities:

[Orenburg](http://en.wikipedia.org/wiki/Orenburg):

![Orenburg](/images/orenburg.png)

[Orsk](http://en.wikipedia.org/wiki/Orsk):

![Orsk](/images/orsk.png)

[Surgut](http://en.wikipedia.org/wiki/Surgut):

![Surgut](/images/surgut.png)

[Tula](http://en.wikipedia.org/wiki/Tula,_Russia):

![Tula](/images/tula.png)
