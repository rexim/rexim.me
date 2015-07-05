package Olyvova::Metadata;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

our @EXPORT_OK = qw(parse_metadata_in_file);

sub parse_metadata_in_file($) {
    my ($file_name) = @_;

    use constant {
        METADATA => 0,
        CONTENT => 1
    };
    my $parse_state = METADATA;

    my %post = ();
    my $content = "";

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

1;
