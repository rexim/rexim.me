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
