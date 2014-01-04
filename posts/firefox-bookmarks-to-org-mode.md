title: Export Firefox's Bookmarks to Org-Mode Document
author: rexim
date: Fri, 03 Jan 2014 11:30:01 +0700
description: Export Firefox's bookmarks to org-mode document

Recently I bought a laptop. And now I need to synchronize my bookmarks
from the web-browser between two devices: desktop and laptop. I use
Mozilla Firefox most of the time. I read about Firefox Sync, but I
don't feel like I want to use it or any other similar services for
other web-browsers.

I decided to try to store my bookmarks in Emacs's org-mode
document. This approach has one significant advantage for me: org-mode
document is a text document, so it can be easily put under the version
control. And the version control allows me to synchronize information
between devices and keeps the history of changes I've made.

First of all, I need to export my current bookmarks from Firefox to
org-mode document. Firefox allows us to export its bookmarks to a JSON
document via the backup feature (`Bookmarks -> Show All Bookmarks ->
Import and Backup -> Backup...`).

The structure of the JSON file is pretty obvious. It's a tree. Every
node represents a bookmark (only if it's a leaf node) or a bookmark
folder. Also every node has several properties. The most important for
us are

* `type` - determines the type of the node; the type
  `text/x-moz-place-container` means it's a bookmark folder; the type
  `text/x-moz-place` means it's a bookmark;
* `children` - a list of child nodes;
* `uri` - URI to the bookmark's place; the nodes with the type
  `text/x-moz-place-container` usually don't have this property;
* `title` - a title of a bookmark folder or a bookmark.

It's enough to write a simple program which parses the JSON,
recursively traverses the tree and produces org-mode document.

I wrote
[a simple python script](https://gist.github.com/rexim/8257108) which
does this. It reads the JSON from stdin and writes the org-mode
document to stdout.
