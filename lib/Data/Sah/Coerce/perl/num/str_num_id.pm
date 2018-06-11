package Data::Sah::Coerce::perl::num::str_num_id;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 3,
        enable_by_default => 0,
        might_fail => 1,
        prio => 50,
        precludes => [qr/\Astr_num_(\w+)\z/],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"Parse::Number::ID"} //= 0;
    $res->{expr_coerce} = join(
        "",
        "do { ",
        "  my \$text = $dt; my \$res = Parse::Number::ID::parse_number_id(text=>$dt); ",
        "  if (!defined \$res) { [qq(Invalid number: \$text)] } ",
        "  else { [undef, \$res] } ",
        "}",
    );

    $res;
}

1;
# ABSTRACT: Parse number using Parse::Number::ID

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["num", "x.perl.coerce_rules"=>["str_num_id"]]
