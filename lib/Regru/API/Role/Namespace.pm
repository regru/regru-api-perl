package Regru::API::Role::Namespace;

# ABSTRACT: Reg.ru API "namespace" role

use strict;
use warnings;
use Moo::Role;
use namespace::autoclean;

requires 'available_methods';

1;  # End of Regru::API::Role::Namespace

__END__

=pod

=head1 NAME

Regru::API::Role::Namespace - Reg.ru API "namespace" role

=head1 SYNOPSYS

    package Regru::API::Dummy;
    ...
    with 'Regru::API::Role::Namespace';

    sub available_methods { [qw(foo bar baz)] }

=head1 DESCRIPTION

...

=head1 SEE ALSO

L<Regru::API::Client>

=cut
