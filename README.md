# Rexim.Me #

Source code of my blog at <http://rexim.me/>.

**If you see any mistakes or typos, please, tell me about them. You
  can even send me a pull request with a fix if you like. :)**

## Usage ##

The blog engine is pretty simple. You write posts in markdown with
metadata (see `./posts/` directory and Markdown Metadata section). Then
run `./site.pl` script to generate static HTML pages. The
script is written in Perl and requires some additional dependencies
(see Dependencies section). And finally, use `./html/` as a root for
web-server.

Before deploying on production, you can test the generated pages using
python's Simple HTTP Server:

    $ cd ./html/
    $ python -m SimpleHTTPServer 3001
    $ <your-favorite-browser> http://localhost:3001/

## Markdown Metadata ##

The `site.pl` uses metadata within markdown
document. Metadata is a key-value table at the top of a document.
Every row of the table matches
`^\s*([a-zA-Z0-9_]+)\s*:\s*(.*)\s*$`. The key is the text before the
colon, and the value is the text after the colon. There must not be
any whitespace above the metadata, and the metadata block ends with
the first line which doesn't match the regexp.

Supported keys:
* `title` &mdash; the title of the post;
* `author` &mdash; who wrote the post;
* `date` &mdash; when the post was published;
* `description` &mdash; what the post is about;

See `./posts/` directory for examples.

## Dependencies ##

First of all, a Perl interpreter is required to run the
`./site.pl` script. The script itself has additional
dependencies (see the top of the script) which you can install through
[CPAN](http://www.cpan.org/).

The script has been tested only on Linux.

## Deployment ##

There is `./deploy.sh` script which helps me to copy the generated
HTML pages to a place where the web-server expects them to see. If you
want to use it too, you have to create `./deploy.config` file. Use
`./deploy.config.example` as an example. All options should be
self-explanatory. Then run `./deploy.sh` as root. Before doing that, I
advise you to look into the script to get the idea of what it really
does.
