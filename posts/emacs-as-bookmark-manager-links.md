title: Emacs as a Bookmark Manager &mdash; Inserting New Links
author: rexim
date: Sat, 08 Feb 2014 19:47:00 +0700
description: Convenient way to bookmark internet links in an org-mode document.

<!-- OMG, markdown sucks! -->
<img src="images/emacs-deal-with-it.png"
     class="left-float-img"
     style="width: 38%;"
     alt="Emacs deal with it" />

After exporting my bookmarks
[from Firefox to an org-mode document](/firefox-bookmarks-to-org-mode.html)
I started to use Emacs as a bookmark manager. After a couple of days,
I realized that I needed to automate some things. I didn't want to
just insert new URLs to the org-mode document. I&nbsp;wanted to insert
them as the org-mode
[links](http://orgmode.org/manual/Link-format.html) with informative
descriptions (for example, the title of the web-page). Apparently, it
is more complex than just `CTRL+C` and then `CTRL+V` the URL. I wanted
the following:

1. I copy a URL to the clipboard,
2. switch to the Emacs window,
3. press some magic keys,
4. and Emacs inserts `[[URL][title of the web-page]]`.

That would be awesome! So I implemented a function which can be bound
to those magic keys:

    (defun cliplink ()
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
            (perform-cliplink ,dest-buffer ,url
                              (buffer-string))))))

As you can see, it's just a skeleton. The main work is done by
`perform-cliplink` function:

    (defun perform-cliplink (buffer url content)
      (let* (;; Decoding the content from UTF-8.
             (decoded-content (decode-coding-string content 'utf-8))
             ;; Extrating and preparing the title.
             (title (prepare-cliplink-title
                     (extract-title-from-html decoded-content))))
        ;; Inserting org-link.
        (with-current-buffer buffer
          (insert (format "[[%s][%s]]" url title)))))

Everything is clear except two functions: `extract-title-from-html`
and `prepare-cliplink-title`. Let's have a look at the first one:

    (defun extract-title-from-html (html)
      (let (;; Start index of the title.
            (start (string-match "<title>" html))
            ;; End index of the title.
            (end (string-match "</title>" html))
            ;; Amount of characters to skip the openning title tag.
            (chars-to-skip (length "<title>")))
        ;; If title is found ...
        (if (and start end (< start end))
            ;; ... extract it and return.
            (substring html (+ start chars-to-skip) end)
          nil)))

The second function is a bit more complex:

    (defun prepare-cliplink-title (title)
      (let (;; Table of replacements which make this title usable for
            ;; org-link. Can be extended.
            (replace-table '(("\\[" . "{")
                             ("\\]" . "}")
                             ("&mdash;" . "—")))
            ;; Maximum length of the title.
            (max-length 77)
            ;; Removing redundant whitespaces from the title.
            (result (straight-string title)))
        ;; Applying every element of the replace-table.
        (dolist (x replace-table)
          (setq result (replace-regexp-in-string (car x) (cdr x) result)))
        ;; Cutting off the title according to its maximum length.
        (when (> (length result) max-length)
          (setq result (concat (substring result 0 max-length) "...")))
        ;; Returning result.
        result))

So, the last function is `straight-string` which helps us to remove
redundant whitespace characters. Here is its implementation:

    (defun straight-string (s)
      ;; Spliting the string and then concatenating it back.
      (mapconcat '(lambda (x) x) (split-string s) " "))

So much code! I hope it is not too hard to read. I just wanted to show
my entire train of thoughts. I've put the complete code
[here](https://gist.github.com/rexim/8883151).
