#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;
use utf8;

use Olyvova::Post qw(compile_posts_dir);
use Olyvova::Pagination qw(make_paginator);
use Olyvova::Builder qw(single multiple pagination build);

sub make_index_page_name($) {
    my ($page_number) = @_;
    if ($page_number > 0) {
        return "index_page_$page_number.html";
    } else {
        return "index.html";
    }
}

my $posts = compile_posts_dir("./posts/");
my $site = {
    assets => "./assets/",
    templates => "./templates/",
    output_dir => "./html/",
    routes => [
        single ("sitemap.xml", "sitemap.tt", {
            posts => $posts,
            baseurl => "http://rexim.me/"
        }),

        single ("rss.xml", "rss.tt", {
            posts => $posts,
            baseurl => "http://rexim.me/"
        }),

        multiple ($posts, sub($) {
            my ($post) = @_;
            my $page_name = $post->{page_name};
            
            single ("$page_name.html", "post.tt", {
                post => $post
            });
        }),

        pagination ($posts, 6, sub($$$) {
            my ($index, $pages_count, $elements_on_page) = @_;
            single (make_index_page_name($index), "index.tt", {
                posts => $elements_on_page,
                paginator => make_paginator($pages_count, $index,
                                            \&make_index_page_name),
                baseurl => "http://rexim.me/"
            });
        })
    ]
};

build($site);

1;
