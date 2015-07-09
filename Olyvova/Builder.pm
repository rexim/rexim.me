package Olyvova::Builder;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

use Data::Dumper;
# TODO: get rid of this dependency
use Switch;

our @EXPORT_OK = qw(single multiple pagination build);

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

sub build_route($$) {
    my ($file_generator, $route) = @_;
    my $route_type = $route->{type};

    switch ($route->{type}) {
        case SINGLE {
            print "SINGLE\n";
        }

        case MULTIPLE {
            print "MULTIPLE\n";
        }

        case PAGINATION {
            print "PAGINATION\n";
        }

        else {
            print "UNKNOWN\n";
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

    foreach (@$routes) {
        build_route($file_generator, $_);
    }
}
