title: Export Bookmarks from Firefox to an Org-Mode Document
author: rexim
date: Sun, 05 Jan 2014 00:42:22 +0700
description: Export bookmarks from Firefox to an org-mode document

I usually do everything on my desktop computer, but recently I
purchased a new laptop (the old one I didn't use at all due to some
hardware issues). And now I need to synchronize my internet bookmarks
between two devices. I use Mozilla Firefox as a web-browser most of
the time. And most of the bookmarks I store there. I read about
Firefox Sync, but I don't feel like I want to use such services.

I decided to try to store my bookmarks in an
[org-mode](http://orgmode.org/) document. This approach has one
significant advantage for me: an org-mode document is a text document,
so it can be easily put under the version control. And the version
control allows me to synchronize information between devices and keeps
the history of changes I've made.

First of all, I need to export my current bookmarks from Firefox to an
org-mode document. Firefox allows us to export its bookmarks to a JSON
file with the backup feature (`Bookmarks -> Show All Bookmarks ->
Import and Backup -> Backup...`).

The structure of the JSON file is pretty obvious. It's a tree. Every
node of the tree represents a bookmark or a bookmark folder. Also
every node has several properties. The most important ones are

* `type` - determines the type of the node; the type
  `text/x-moz-place-container` means it's a bookmark folder; the type
  `text/x-moz-place` means it's a bookmark;
* `children` - a list of child nodes;
* `uri` - URI to the bookmark's place; the nodes with the type
  `text/x-moz-place-container` usually don't have this property;
* `title` - a title of a bookmark folder or a bookmark.

It's enough to write a simple program which parses the JSON,
recursively traverses the tree and produces the org-mode document.

I wrote
[a simple python script](https://gist.github.com/rexim/8257108) which
does this. It reads the JSON from stdin and writes the org-mode
document to stdout. It translates folders to
[headlines](http://orgmode.org/manual/Headlines.html) and bookmarks to
[list items](http://orgmode.org/manual/Plain-lists.html).
