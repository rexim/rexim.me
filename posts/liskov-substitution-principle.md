title: Liskov Substitution Principle
author: rexim
date: Thu, 19 Dec 2013 20:10:38 +0700
description: A simple explanation of the Liskov Substitution Priciple.

<!-- OMG, markdown sucks! -->
<img src="images/LSP.png"
     style="float: left; width: 50%; margin-right: 20px;"
     alt="Lumpy Space Princess" />

The most mysterious [SOLID](http://en.wikipedia.org/wiki/SOLID)
principle for me was always the third one. The
[Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)
(LSP). I knew that classical example about deriving Square from
Rectangle, but I didn't understand why it is violation of LSP.

The principle has a pretty simple idea. A class is not just a set of
methods and fields. We also have a number of assumptions about
them. These assumptions are often called properties. And when we use
the class somewhere we usually rely on this properties. Let's consider
as an example the following class:

    public class Date {
      ...
      public int getMonthNumber() { ... }
      ...
    }

The method `getMonthNumber()` must return an integer. And the property
is the integer should lie on the interval `[1 .. 12]`. As you can see,
a property is something beyond method's signature. It can't be checked
in compile time. We should provide it ourselves.

It's pretty simple example, but I think it is enough to understand
what property is and now we can formalize the idea of LSP:

> A subclass of a class should derive its properties as well as its
> methods and fields. Thus an object of the class can be safely
> substituted by an object of the subclass without violating
> correctness of the program.

Let's get back to the Square-Rectangle example. A square is actually a
particular case of a rectangle. So `Rectangle` is a base class for
`Square`. We can define it as follow:

    public class Rectangle {
        public void setWidth(int x) {
            width = x;
        }

        public void setHeight(int x) {
            height = x;
        }

        public int getWidth() {
            return width;
        }

        public int getHeight() {
            return height;
        }

        protected int width = 0;
        protected int height = 0;
    }

The class has two fields: `width` and `height`, and two setters and
getters for them.

Now we can define `Square` class by extending `Rectangle`. A square is
a rectangle with equal edges. This can be achived by overriding
`Rectangle`'s setters:

    public class Square extends Rectangle {
        @Override
        public void setWidth(int x) {
            super.setWidth(x);
            height = x;
        }

        @Override
        public void setHeight(int x) {
            super.setHeight(x);
            width = x;
        }
    }

This approach has several problems. First of all, it is some sort of
overhead to have `width` and `height` for `Square` since they're
always equal. It would be better to have only one parameter which
represents length of edge.

The second problem is `Square` alters one of the `Rectangle`'s
properties. `Rectangle`'s setters change only one
parameter. `setWidget` changes only `width`, `setHeight` changes only
`height`. But for `Square` every setter changes both parameters. The
code which may use `Rectangle` probably doesn't even assume that. LSP
has been violated!

It is better not to treat `Rectangle` as a base class of `Square`.
