#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;
use utf8;

use File::Copy::Recursive qw(dircopy);

use Olyvova::Post qw(compile_posts_dir);
use Olyvova::Pagination qw(filter_posts_by_current_page get_pages_count make_paginator);
use Olyvova::Template qw(make_file_generator);

sub make_index_page_name($) {
    my ($page_number) = @_;
    if ($page_number > 0) {
        return "index_page_$page_number.html";
    } else {
        return "index.html";
    }
}

sub main {
    if (-d "./html/") {
        rmdir("./html/");
    }

    dircopy("./assets/", "./html/");

    my $posts = compile_posts_dir("./posts/");
    my $generate_file = make_file_generator("./templates", "./html");

    $generate_file->("sitemap.xml", "sitemap.tt",
                     { posts => $posts,
                       baseurl => "http://rexim.me/" });
    $generate_file->("rss.xml", "rss.tt",
                     { posts => $posts,
                       baseurl => "http://rexim.me/" });

    # Generate posts
    foreach(@$posts) {
        my $page_name = $_->{page_name};
        $generate_file->("$page_name.html", "post.tt",
                         { post => $_ });
    }

    # Generate pages
    my $page_size = 6;
    my $pages_count = get_pages_count($posts, $page_size);
    for (my $i = 0; $i < $pages_count; $i++) {
        $generate_file->(make_index_page_name($i), "index.tt",
                         { posts => filter_posts_by_current_page($posts, $page_size, $i),
                           paginator => make_paginator($pages_count, $i,
                                                       \&make_index_page_name),
                           basurl => "http://rexim.me/" });
    }
}

main();

1;
