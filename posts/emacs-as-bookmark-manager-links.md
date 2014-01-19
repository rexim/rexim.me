title: Emacs as a Bookmark Manager &mdash; Inserting New Links
author: rexim
date: Sun, 19 Jan 2014 14:05:43 +0700
description: Explains how to insert a link to an org-mode document by URL from the clipboard.

<!-- OMG, markdown sucks! -->
<img src="images/emacs-deal-with-it.png"
     style="float: left; width: 35%; margin-right: 20px;" />

After exporting my bookmarks
[from Firefox to an org-mode document](/firefox-bookmarks-to-org-mode.html)
I started to use Emacs as a bookmark manager. After a couple of days,
I realized that I needed to automate some things. I didn't want to
just insert new URLs to the org-mode document. I wanted to insert them
as the org-mode [links](http://orgmode.org/manual/Link-format.html)
with informative description (for example, with the title of the
web-page). And it is more complex than just `CTRL+C` and then `CTRL+V`
the URL. I needed this feature:

1. I copy a URL to the clipboard,
2. switch to the Emacs window,
3. press some magic keys,
4. and Emacs inserts `[[URL][title of the web-page]]`.

That would be awesome! So I implemented this function which can be
bound to those magic keys:

    (defun insert-new-linnk ()
      (interactive)
      (let ((dest-buffer (current-buffer))
            (url (substring-no-properties (current-kill 0))))
        (url-retrieve
         url
         `(lambda (s)
            (goto-char (point-max))
            (search-backward-regexp
             "<title>[[:space:]\n]*\\(.*\\)[[:space:]\n]*</title>")
            (let ((title (match-string 1)))
              (with-current-buffer ,dest-buffer
                (insert (format "[[%s][%s]]" ,url title))))))))

This snippet has three key elements:

1. `(substring-no-properties (current-kill 0))`  returns content
   of the clipboard;
2. function `url-retrieve` makes an HTTP-request to the given URL
   &mdash; the request is asynchronous, so the function requires a
   callback which is called when the result has been completely
   retrieved, with the current buffer containing the result;
3. function `search-backward-regexp` searches in the current buffer by
   the given regexp, so I can extract the title of the web-page using
   group capturing (see function `match-string`).

The function works even on Windows. There is a little problem with
unicode titles, but I'm going to solve it later.
