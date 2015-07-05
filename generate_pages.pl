#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;
use utf8;

use File::Copy::Recursive qw(dircopy);
use Data::Dumper;
use DateTime;
use DateTime::Format::RFC3339;
use DateTime::Format::Mail;
use Text::Markdown 'markdown';
use File::Basename;
use Template;
use List::Util qw[min max];
use POSIX qw/ceil/;

sub parse_post_file {
    use constant {
        METADATA => 0,
        CONTENT => 1
    };
    my $parse_state = METADATA;

    my %post = ();
    my $content = "";

    my ($file_name) = @_;
    open(my $fh, $file_name);
    binmode($fh, ':utf8');
    while (<$fh>) {
        if ($parse_state == METADATA) {
            if (my ($key, $value) = $_ =~ m/^\s*([a-zA-Z0-9_]+)\s*:\s*(.*)\s*$/) {
                $post{lc $key} = $value;
            } else {
                $parse_state = CONTENT;
                $content = $content . $_;
            }
        } else {
            $content = $content . $_;
        }
    }
    close($fh);

    $post{content} = $content;

    return \%post;
}

sub get_post_files_form_dir {
    my ($posts_directory) = @_;
    my @posts = ();

    opendir(my $dh, $posts_directory) or die $!;
    while (my $file = readdir($dh)) {
        if ($file =~ m/.*\.md/) {
            push @posts, "$posts_directory/$file";
        }
    }
    closedir($dh);

    return \@posts;
}

sub compile_post_files {
    my ($post_file_names) = @_;
    my $rfc3339 = DateTime::Format::RFC3339->new();
    my @posts = ();

    foreach (@$post_file_names) {
        my $page_name = basename $_, (".md");
        my $post = parse_post_file($_);
        my $date = DateTime::Format::Mail->parse_datetime($post->{date});
        $date->set_formatter($rfc3339);

        $post->{content} = markdown($post->{content});
        $post->{date} = $date;
        $post->{page_name} = $page_name;

        push @posts, $post;
    }

    @posts = sort {
        DateTime->compare($b->{date}, $a->{date});
    } @posts;

    return \@posts;
}

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

sub make_index_page_name($) {
    my ($page_number) = @_;
    if ($page_number > 0) {
        return "index_page_$page_number.html";
    } else {
        return "index.html";
    }
}

sub make_paginator($$) {
    my ($pages_count, $current_page) = @_;
    my $paginator = {
        page_buttons => []
    };

    for (my $i = 0; $i < $pages_count; $i++) {
        my $page_button = {
            label => "$i",
            is_current => $i == $current_page
        };

        if (!$page_button->{is_current}) {
            $page_button->{href} = make_index_page_name($i);
        }

        push $paginator->{page_buttons}, $page_button
    }

    return $paginator;
}

sub main {
    if (-d "./html/") {
        rmdir("./html/");
    }

    dircopy("./assets/", "./html/");

    my $posts = compile_post_files(get_post_files_form_dir("./posts/"));
    my $template = Template->new({ RELATIVE => 1,
                                   INCLUDE_PATH => "./templates",
                                   ENCODING => 'utf8' });

    my $generate_file = sub {
        my ($file_name, $template_name, $context) = @_;

        if (not defined $context) {
            $context = { posts => $posts,
                         baseurl => "http://rexim.me/" };
        }

        print "[INFO] $file_name ...";
        $template->process("./templates/$template_name",
                           $context,
                           "./html/$file_name",
                           { binmode => ':utf8' }) || die $template->error();
        print " DONE\n";
    };

    $generate_file->("sitemap.xml", "sitemap.tt");
    $generate_file->("rss.xml", "rss.tt");

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
                           paginator => make_paginator($pages_count, $i),
                           basurl => "http://rexim.me/" });
    }
}

main();

1;
