title: Emacs HOME for Windows
author: rexim
date: Wed, 18 Feb 2015 01:24:33 +0600
description: About how Emacs finds the home directory under Windows and how configure that

One thing that always bugged me about Emacs is that when it runs under
Windows it thinks that the home directory is `%APPDATA%`. That leads
to thousand problems with other software that is supposed to be run
from within Emacs. Like, for example, git. When I use git outside of
Emacs it acts like `%USERPROFILE%` is the home directory. I mean
`%USERPROFILE%` really IS the home directory, and the git's behaviour
is rather logical. But when I run git from within Emacs using
something like `start-process-shell-command` function (yes, I actually
[do this](https://github.com/rexim/emacs.rc/blob/3908e2e2560ef5bf64bef95dff1e48ca3dac7786/.emacs.rc/org-mode-rc.el#L37),
it is required to automatically synchronize my org-mode notes between
different devices), it thinks that it is in completelly different
environment.

There is a
[little section in the official Emacs documentation](https://www.gnu.org/software/emacs/manual/html_node/emacs/Windows-HOME.html)
dedicated to the home directory under Windows. The easiest solution
for me is just to define `%HOME%` variable and target it to
`%USERPROFILE%`. So, I did it in the console:

    setx HOME %USERPROFILE%

Actually it would be nice to have this solution as a part of my
config. Something like, when the OS is Windows just `setenv` the HOME
variable to the correct place. I'll check if this works when I have
spare time.
