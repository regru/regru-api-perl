package Regru::API::Role::Serializer;

# ABSTRACT: REG.API v2 "serializer" role

use strict;
use warnings;
use Moo::Role;
use JSON;
use Carp ();
use namespace::autoclean;

# VERSION
# AUTHORITY

has serializer => (
    is      => 'rw',
    isa     => sub { Carp::croak "$_[0] is not a JSON instance" unless ref $_[0] eq 'JSON' },
    lazy    => 1,
    default => sub { JSON->new->utf8 },
);

1;  # End of Regru::API::Role::Serializer

__END__

=pod

=head1 SYNOPSYS

    package Regru::API::Client;
    ...
    with 'Regru::API::Role::Serializer';

=head1 DESCRIPTION

...

=head1 METHODS/ATTRIBUTES

=head2 serializer

...

=head1 SEE ALSO

L<Regru::API::Client>

=cut
