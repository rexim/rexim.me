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
assumption is the integer should lie on `[1 .. 12]`. As you can see,
an assumption is something beyond method's signature. It can't be
checked in compile time. We should provide it ourselves.

It's quite simple example, but I think it's enough to formalize the
idea of LSP:

> A subclass of a class should derive its assumptions (properties) as
> well as its methods and fields. So in the code an object of the
> class can be safely substituted by an object of the subclass without
> violating correctness of the program.

Let's get back to the Square-Rectangle example. Rectangle:

    class Rectangle {
      var width: Int;
      var height: Int;

      def getWidth: Int = {
        return width;
      }

      def getHeight: Int = {
        return height;
      }

      def setWidth(x : Int) = {
        width = x;
      }

      def setHeight(x : Int) = {
        height = x;
      }
    }

Square:

    class Square extends Rectangle {
      override def setWidget(x : Int) = {
        width = x;
        height = x;
      }

      override def setHeight(y : Int) = {
        width = x;
        height = x;
      }
    }
