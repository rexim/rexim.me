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
file (`Bookmarks -> Show All Bookmarks -> Import and Backup ->
Backup...`).

The structure of the JSON file is pretty obvious. It's a tree. Every
node of the tree represents a bookmark or a bookmark folder. Also
every node has several properties. The most important ones are

* `type` &mdash; determines the type of the node; the type
  `text/x-moz-place-container` means it's a bookmark folder; the type
  `text/x-moz-place` means it's a bookmark;
* `children` &mdash; a list of child nodes;
* `uri` &mdash; URI to the bookmark's place; the nodes with the type
  `text/x-moz-place-container` usually don't have this property;
* `title` &mdash; a title of a bookmark folder or a bookmark.

With the omitted unnecessary properties the JSON will look this:

    {
        "title": "Bookmarks Toolbar",
        "type": "text/x-moz-place-container",
        "children": [
            {
                "title": "Search Engines",
                "type": "text/x-moz-place-container",
                "children": [
                    {
                        "title": "Google",
                        "type": "text/x-moz-place",
                        "uri": "https://www.google.com/"
                    },
                    {
                        "title": "Yandex",
                        "type": "text/x-moz-place",
                        "uri": "http://www.yandex.com/"
                    }
                ]
            },
            {
                "title": "Social Networks",
                "type": "text/x-moz-place-container",
                "children": [
                    {
                        "title": "Twitter",
                        "type": "text/x-moz-place",
                        "uri": "https://twitter.com/"
                    },
                    {
                        "title": "Facebook",
                        "type": "text/x-moz-place",
                        "uri": "https://www.facebook.com/"
                    }
                ]
            }
        ]
    }

It's enough to write a simple program which parses the JSON,
recursively traverses the tree and produces the org-mode document.

I wrote
[a simple python script](https://gist.github.com/rexim/8257108) which
does this. It reads the JSON from stdin and writes the org-mode
document to stdout. It translates folders to
[headlines](http://orgmode.org/manual/Headlines.html) and bookmarks to
[list items](http://orgmode.org/manual/Plain-lists.html).

With the script the above JSON example will be converted to this:

    * Bookmarks Toolbar
    ** Search Engines
       - [[https://www.google.com/][Google]]
       - [[http://www.yandex.com/][Yandex]]
    ** Social Networks
       - [[https://twitter.com/][Twitter]]
       - [[https://www.facebook.com/][Facebook]]
