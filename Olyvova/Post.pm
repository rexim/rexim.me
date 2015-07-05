package Olyvova::Post;

use 5.10.1;

use strict;
use warnings;
use utf8;

use DateTime;
use DateTime::Format::RFC3339;
use DateTime::Format::Mail;
use File::Basename;
use Text::Markdown 'markdown';

use Olyvova::Metadata qw(parse_metadata_in_file);

use Exporter qw(import);

our @EXPORT_OK = qw(compile_post_file list_post_files_in_dir compile_post_files compile_posts_dir);

sub compile_post_file($$) {
    my $rfc3339 = DateTime::Format::RFC3339->new();

    my ($page_name, $file_name) = @_;
    my $post = parse_metadata_in_file($file_name);
    my $date = DateTime::Format::Mail->parse_datetime($post->{date});
    $date->set_formatter($rfc3339);

    $post->{content} = markdown($post->{content});
    $post->{date} = $date;
    $post->{page_name} = $page_name;

    return $post;
}

sub list_post_files_in_dir {
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
    my @posts = ();

    foreach (@$post_file_names) {
        my $page_name = basename $_, (".md");
        my $post = compile_post_file($page_name, $_);
        push @posts, $post;
    }

    @posts = sort {
        DateTime->compare($b->{date}, $a->{date});
    } @posts;

    return \@posts;
}

sub compile_posts_dir($)
{
    my ($posts_dir) = @_;
    return compile_post_files(list_post_files_in_dir("./posts/"));
}
