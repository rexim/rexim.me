# Rexim.Me #

Source code of my blog at <http://rexim.me/>.

## Usage ##

The blog engine is pretty simple. You write posts in markdown with
metadata (see `./post/` directory and Markdown Metadata
section). Then run `./generate_pages.pl` script to generate static
html pages. The script is written in Perl and requires some additional
dependencies (see Dependencies section). And finally, use `./html/` as
a root for web-server.

Before deploying on production, you can test the generated pages using
python's Simple HTTP Server:

    $ cd ./html/
    $ python -m SimpleHTTPServer 3001
    $ <your-favorite-browser> http://localhost:3001/

## Markdown Metadata ##

The `generate_pages.pl` uses metadata within markdown
document. Metadata is a key-value table at the top of a markdown
documented. Every row of the table matches
`^\s*([a-zA-Z0-9_]+)\s*:\s*(.*)\s*$`. The key is the text before the
colon, and the value is the text after the colon. There must not be
any whitespace above the metadata, and the metadata block ends with
the first line which doesn't match the regexp.

Supported keys:
* `title` - the title of the post;
* `author` - who wrote the post;
* `date` - when the post was published;
* `description` - what the post is about;

See `./posts/` directory for examples.

# Dependencies #

First of all, a Perl interpreter is required to run the
`./generate_pages.pl` script. The script itself has additional
dependencies (see the top of the script) which you can install through
[CPAN](http://www.cpan.org/).

The script has been tested only under Linux.
