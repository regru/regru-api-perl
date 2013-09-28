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

Any class or role that consumes this one will considered as a namespace (or category) in REG.API v2.

=reqs available_methods

A list of methods (as array reference) provides by namespace. An empty array reference should be used in
case of namespace does not provide any methods. But this so odd...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
