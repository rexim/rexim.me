#!/usr/bin/env perl

use Data::Dumper;
use DateTime;
use DateTime::Format::RFC3339;
use DateTime::Format::Mail;
use Text::Markdown 'markdown';
use File::Basename;
use YAML 'LoadFile';
use Template;

sub parse_post_file {
    LoadFile @_;
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

my $post_file_names = get_all_post_files("./posts/");
my @posts = ();
my $template = Template->new({ RELATIVE => 1, INCLUDE_PATH => "./templates" });
my $rfc3339 = DateTime::Format::RFC3339->new();

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

print "index.html ... ";
$template->process("./templates/index.tt",
                   { posts => \@posts },
                   "./html/index.html",
                   { binmode => ':utf8' }) || die $template->error();
print "DONE\n";

foreach(@posts) {
    my $page_name = $_->{page_name};
    print "$page_name.html ... ";
    $template->process("./templates/post.tt",
                       $_,
                       "./html/$page_name.html",
                       { binmode => ':utf8' }) || die $template->error();
    print "DONE\n";
}

true;
