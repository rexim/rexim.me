title: Liskov Substitution Principle
author: rexim
date: Sun, 15 Dec 2013 23:44:17 +0700

<!-- OMG, markdown sucks! -->
<!-- <img src="images/LSP.png" style="float: left; width: 50%; margin-right: 20px;" /> -->

The most mysterious [SOLID](http://en.wikipedia.org/wiki/SOLID)
principle for me was always the third one. The
[Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)
(LSP). I knew that classical example about deriving Square from
Rectangle, but I didn't understand why it is violation of LSP.

The principle has a pretty simple idea. A class is not just a set of
methods and fields. We also have a number of assumption (they also
called properties) between them. And when we use the class somewhere
we usually rely on this assumptions. Let's consider as an example the
following class:

    class Date {
      ...
      def getMonthNumber(): Int
      ...
    }

The method `getMonthNumber()` must return an integer. And the
assumption is the integer should lie on `[1 .. 12]` interval.

So the idea of LSP is

> a subclass of a class should derive its assumptions (properties) as well
> as its methods and fields.

It is important because then the class can be safely substituted by
the subclass without violation correctness of the program (that's why
it's called a substitution principle).
