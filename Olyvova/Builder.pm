package Olyvova::Builder;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

use Data::Dumper;

our @EXPORT_OK = qw(single multiple pagination build);

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
    }
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

sub build($) {
    print Dumper($_[0]);
}
