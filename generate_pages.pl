#!/usr/bin/env perl

use 5.10.1;

use strict;
use warnings;
use utf8;

use Data::Dumper;
use DateTime;
use DateTime::Format::RFC3339;
use DateTime::Format::Mail;
use Text::Markdown 'markdown';
use File::Basename;
use Template;

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

sub get_all_post_files {
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

sub prepare_posts {
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

sub settings_from_args {
    my ($settings) = @_;
    foreach (@ARGV) {
        if ($_ eq '--comments-enabled') {
            $settings->{comments_enabled} = 1;
        } else {
            die "$_ is unknown option\n";
        }
    }
}

sub main {
    my $settings = {
        comments_enabled => 0
    };
    settings_from_args($settings);

    print Dumper($settings), "\n";

    my $posts = prepare_posts(get_all_post_files("./posts/"));
    my $template = Template->new({ RELATIVE => 1,
                                   INCLUDE_PATH => "./templates",
                                   ENCODING => 'utf8' });

    my $generate_file = sub {
        my ($file_name, $template_name, $context) = @_;

        if (not defined $context) {
            $context = { posts => $posts,
                         baseurl => "http://rexim.me/",
                         settings => $settings };
        }

        print "[INFO] $file_name ...";
        $template->process("./templates/$template_name",
                           $context,
                           "./html/$file_name",
                           { binmode => ':utf8' }) || die $template->error();
        print "DONE\n";
    };

    $generate_file->("index.html", "index.tt");
    $generate_file->("sitemap.xml", "sitemap.tt");
    $generate_file->("rss.xml", "rss.tt");

    foreach(@$posts) {
        my $page_name = $_->{page_name};
        $generate_file->("$page_name.html", "post.tt",
                         { post => $_,
                           settings => $settings});
    }
}

main();

1;
