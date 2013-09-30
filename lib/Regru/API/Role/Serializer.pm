package Regru::API::Role::Serializer;

# ABSTRACT: REG.API v2 "serializer" role

use strict;
use warnings;
use Moo::Role;
use JSON;
use Carp;
use namespace::autoclean;

# VERSION
# AUTHORITY

has serializer => (
    is      => 'rw',
    isa     => sub { croak "$_[0] is not a JSON instance" unless ref $_[0] eq 'JSON' },
    lazy    => 1,
    default => sub { JSON->new->utf8 },
);

1;  # End of Regru::API::Role::Serializer

__END__

=pod

=head1 SYNOPSIS

    package Regru::API::Client;
    ...
    with 'Regru::API::Role::Serializer';

    $str = $self->serializer->encode({ answer => 42, foo => [qw(bar baz quux)] });

=head1 DESCRIPTION

Any class or role that consumes this one will able to (de)serialize JSON.

=attr serializer

Returns an L<JSON> instance with B<utf8> option enabled.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<JSON>

=cut
