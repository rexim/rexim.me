package Olyvova::Builder;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

use Data::Dumper;
use Switch;                     # TODO: get rid of this dependency
use File::Copy::Recursive qw(dircopy);

our @EXPORT_OK = qw(single multiple pagination build);

use Olyvova::Pagination qw(filter_posts_by_current_page get_pages_count make_paginator);
use Olyvova::Template qw(make_file_generator);

use constant {
    SINGLE => 'single',
    MULTIPLE => 'multiple',
    PAGINATION => 'pagination'
};

sub single($$$) {
    my ($file_name, $template_name, $context) = @_;
    {
        type => SINGLE,
        file_name => $file_name,
        template_name => $template_name,
        context => $context
    };
}

sub multiple($$) {
    my ($elements, $transformer) = @_;
    {
        type => MULTIPLE,
        elements => $elements,
        transformer => $transformer
    };
}

sub pagination($$$) {
    my ($elements, $page_size, $transformer) = @_;
    {
        type => PAGINATION,
        elements => $elements,
        page_size => $page_size,
        transformer => $transformer
    };
}

sub build_route {
    my ($file_generator, $route) = @_;
    my $route_type = $route->{type};

    switch ($route_type) {
        case SINGLE {
            $file_generator->($route->{file_name},
                              $route->{template_name},
                              $route->{context});
        }

        case MULTIPLE {
            my $elements = $route->{elements};
            my $transformer = $route->{transformer};

            foreach (@$elements) {
                build_route($file_generator, $transformer->($_));
            }
        }

        case PAGINATION {
            my $elements = $route->{elements};
            my $page_size = $route->{page_size};
            my $transformer = $route->{transformer};
            my $pages_count = get_pages_count($elements, $page_size);

            for (my $i = 0; $i < $pages_count; $i++) {
                my $elements_on_page =
                    filter_posts_by_current_page($elements, $page_size, $i);
                my $page_route = $transformer->($i, $pages_count, $elements_on_page);
                build_route($file_generator, $page_route);
            }
        }

        else {
            print "[WARN] Unknown route type $route_type. Skipping... \n";
        }
    }
}

sub build($) {
    my ($site) = @_;
    my $assets = $site->{assets};
    my $templates = $site->{templates};
    my $output_dir = $site->{output_dir};
    my $routes = $site->{routes};
    my $file_generator = make_file_generator($templates, $output_dir);

    if (-d $output_dir) {
        rmdir($output_dir);
    }

    dircopy($assets, $output_dir);

    foreach (@$routes) {
        build_route($file_generator, $_);
    }
}
