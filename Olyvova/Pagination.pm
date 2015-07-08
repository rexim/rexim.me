package Olyvova::Pagination;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

our @EXPORT_OK = qw(filter_posts_by_current_page get_pages_count make_paginator);

use POSIX qw(ceil);
use List::Util qw(min);

sub filter_posts_by_current_page($$$) {
    my ($posts, $page_size, $current_page) = @_;

    my $posts_count = @$posts;
    my $lower_bound = $current_page * $page_size;
    my $upper_bound = min(($current_page + 1) * $page_size, $posts_count) - 1;

    if ($lower_bound <= $upper_bound) {
        my @xs = @$posts[$lower_bound .. $upper_bound];
        return \@xs;
    } else {
        return [];
    }
}

sub get_pages_count($$) {
    my ($posts, $page_size) = @_;
    my $posts_count = @$posts;
    return ceil($posts_count / $page_size);
}

sub make_paginator($$$) {
    my ($pages_count, $current_page, $make_page_name) = @_;
    my $paginator = {
        page_buttons => []
    };

    for (my $i = 0; $i < $pages_count; $i++) {
        my $page_button = {
            label => "$i",
            is_current => $i == $current_page
        };

        if (!$page_button->{is_current}) {
            $page_button->{href} = $make_page_name->($i);
        }

        push $paginator->{page_buttons}, $page_button
    }

    return $paginator;
}
