title: Emacs as a Bookmark Manager &mdash; Inserting New Links
author: rexim
date: Sun, 19 Jan 2014 14:05:43 +0700
description: Explains how to insert a link to an org-mode document by URL from the clipboard.

<!-- OMG, markdown sucks! -->
<img src="images/emacs-deal-with-it.png"
     style="float: left; width: 35%; margin-right: 20px;"
     alt="Emacs deal with it" />

After exporting my bookmarks
[from Firefox to an org-mode document](/firefox-bookmarks-to-org-mode.html)
I started to use Emacs as a bookmark manager. After a couple of days,
I realized that I needed to automate some things. I didn't want to
just insert new URLs to the org-mode document. I&nbsp;wanted to insert
them as the org-mode
[links](http://orgmode.org/manual/Link-format.html) with informative
description (for example, with the title of the web-page). And it is
more complex than just `CTRL+C` and then `CTRL+V` the URL. I needed
this feature:

1. I copy a URL to the clipboard,
2. switch to the Emacs window,
3. press some magic keys,
4. and Emacs inserts `[[URL][title of the web-page]]`.

That would be awesome! So I implemented this function which can be
bound to those magic keys:

    (defun rc/cliplink ()
      ;; Of course, this function is interactive. :)
      (interactive)
      (let (;; Remembering the current buffer, 'cause it is a destination
            ;; buffer we are inserting the org-link to.
            (dest-buffer (current-buffer))
            ;; Getting URL from the clipboard. Since it may contain
            ;; some text properties we are using substring-no-properties
            ;; function.
            (url (substring-no-properties (current-kill 0))))
        ;; Retrieving content by URL.
        (url-retrieve
         url
         ;; Performing an action on the retrieved content.
         `(lambda (s)
            (rc/perform-cliplink ,dest-buffer ,url
                                 (buffer-string))))))

As you can see, it's just a skeleton. The main work is done by
function `rc/perform-cliplink`:

    (defun rc/perform-cliplink (buffer url content)
      (let* (;; Decoding the content
             (decoded-content (decode-coding-string content 'utf-8))
             ;; Extrating and preparing the title
             (title (rc/prepare-cliplink-title
                     (rc/extract-title-from-html decoded-content))))
        ;; Inserting org-link
        (with-current-buffer buffer
          (insert (format "[[%s][%s]]" url title)))))

Everything is clear except two functions: `rc/extract-title-from-html`
and `rc/prepare-cliplink-title`. Let's have a look at the first one:

    (defun rc/extract-title-from-html (html)
      (let (;; Start index of the title
            (start (string-match "<title>" html))
            ;; End index of the title
            (end (string-match "</title>" html))
            ;; Amount of characters to skip the title tag
            (chars-to-skip (length "<title>")))
        ;; If title is found ...
        (if (and start end (< start end))
            ;; ... extract it and return
            (substring html (+ start chars-to-skip) end)
          nil)))

The second function is a bit more complex:

    (defun rc/prepare-cliplink-title (title)
      (let (;; Table of replacements which make this title usable for
            ;; org-link. Can be extended.
            (replace-table '(("\\[" . "{")
                             ("\\]" . "}")
                             ("&mdash;" . "—")))
            ;; Maximum length of the title
            (max-length 77)
            ;; Removing redundant whitespaces from the title.
            (result (rc/straight-string title)))
        ;; Applying every element of the replace-table.
        (dolist (x replace-table)
          (setq result (replace-regexp-in-string (car x) (cdr x) result)))
        ;; Cutting off the title according to its maximum length.
        (when (> (length result) max-length)
          (setq result (concat (substring result 0 max-length) "...")))
        ;; Returning result
        result))

So, the last function is `rc/straight-string` which helps us to remove
redundant whitespace characters. Here is its implementation:

    (defun rc/straight-string (s)
      ;; Spliting the string and then concatenating it back does the work.
      (mapconcat '(lambda (x) x) (split-string s) " "))

So much code! I hope it is not too hard to read. I just wanted to show
my entire train of thoughts.
