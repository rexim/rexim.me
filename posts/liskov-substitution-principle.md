title: Liskov Substitution Principle
author: rexim
date: Sun, 15 Dec 2013 23:44:17 +0700
content: |-

  The most mysterious [SOLID](http://en.wikipedia.org/wiki/SOLID)
  principle for me was always the third one. The
  [Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)
  (LSP). I knew that classical example with deriving Square from
  Rectangle, but I didn't understand why it is violation of LSP.

  The principle has a pretty simple idea. When we define a class we
  define more than just a set of methods and fields. We have also a
  set of assumptions (or properties) between these methods and
  fields. For example, we have a class with the following method:

  <pre><code>def getMonthNumber(): Int</code></pre>

  This method must return an integer. And the assumption above this
  method is the integer should be between 1 and 12. So the idea of LSP
  isthe subtype of the class should derive both the method and
  assumption.
