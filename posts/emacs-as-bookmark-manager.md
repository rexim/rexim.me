title: Emacs as a Bookmark Manager
author: rexim
date: Sun, 12 Jan 2014 21:44:18 +0700
description: Explains how to insert a link to an org-mode document by URL from the clipboard.

<!-- OMG, markdown sucks! -->
<img src="images/emacs-deal-with-it.png" style="float: left; width: 35%; margin-right: 20px;" />

After exporting my bookmarks
[from Firefox to an org-mode document](/firefox-bookmarks-to-org-mode.html)
I started to use Emacs as a bookmark manager. After a couple of days,
I realized that I needed to automate some things. I didn't want to
just insert new URLs to the org-mode document. I wanted to insert them
as the org-mode [links](http://orgmode.org/manual/Link-format.html)
with informative description (for example, with the title of the
web-page). And it is more complex than just `CTRL+C`, `CTRL+V` the
URL. I needed this feature:

1. I copy a URL to clipboard;
2. switch to the Emacs window;
3. press some magic keys;
4. Emacs inserts `[[URL][title of the web-page]]`

That would be awesome! How to implement this?

The first step is to retrieve information from the clipboard.
