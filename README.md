# Rexim.Me #

Source code of my blog at <http://rexim.me/>.

**If you see any mistakes or typos, please, tell me about them. You
  can even send me a pull request with a fix if you like. :)**

## Usage ##

This blog uses [Olyvova](https://github.com/rexim/Olyvova) static blog
generator. You write posts in markdown with metadata (see `./posts/`
directory and
[Markdown Metadata section](https://github.com/rexim/Olyvova/blob/c173e4e1fc6280cb58adcce6e6f5739f1d7d586d/README.md#markdown-metadata)). Then
run `./site.pl` script to generate static HTML pages. The script is
written in Perl and requires some additional dependencies (see
[Dependencies section](https://github.com/rexim/Olyvova/blob/c173e4e1fc6280cb58adcce6e6f5739f1d7d586d/README.md#dependencies)). And
finally, use `./html/` as a root for web-server.

Before deploying on production, you can test the generated pages using
python's Simple HTTP Server:

    $ cd ./html/
    $ python -m SimpleHTTPServer 3001
    $ <your-favorite-browser> http://localhost:3001/

## Deployment ##

There is `./deploy.sh` script which helps me to copy the generated
HTML pages to a place where the web-server expects them to see. If you
want to use it too, you have to create `./deploy.config` file. Use
`./deploy.config.example` as an example. All options should be
self-explanatory. Then run `./deploy.sh` as root. Before doing that, I
advise you to look into the script to get the idea of what it really
does.
