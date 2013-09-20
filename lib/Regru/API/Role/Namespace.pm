package Regru::API::Role::Namespace;

# ABSTRACT: REG.API v2 "namespace" role

use strict;
use warnings;
use Moo::Role;
use namespace::autoclean;

# VERSION
# AUTHORITY

requires 'available_methods';

1;  # End of Regru::API::Role::Namespace

__END__

=pod

=head1 SYNOPSIS

    package Regru::API::Dummy;
    ...
    with 'Regru::API::Role::Namespace';

    sub available_methods { [qw(foo bar baz)] }

=head1 DESCRIPTION

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Client>

=cut
