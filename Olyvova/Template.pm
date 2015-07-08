package Olyvova::Template;

use 5.10.1;

use strict;
use warnings;
use utf8;

use Exporter qw(import);

our @EXPORT_OK = qw(make_file_generator);

use Template;

sub make_file_generator($$)
{
    my ($templates_dir, $output_dir) = @_;
    my $template = Template->new({ RELATIVE => 1,
                                   INCLUDE_PATH => $templates_dir,
                                   ENCODING => 'utf8' });
    return sub($$$) {
        my ($file_name, $template_name, $context) = @_;

        print "[INFO] $file_name ...";
        $template->process("$templates_dir/$template_name",
                           $context,
                           "$output_dir/$file_name",
                           { binmode => ':utf8' }) || die $template->error();
        print " DONE\n";
    };
}
