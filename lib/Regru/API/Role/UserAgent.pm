package Regru::API::Role::UserAgent;

# ABSTRACT: REG.API v2 "user agent" role

use strict;
use warnings;
use Moo::Role;
use LWP::UserAgent;
use Carp ();
use namespace::autoclean;

# VERSION
# AUTHORITY

has useragent => (
    is      => 'rw',
    isa     => sub { Carp::croak "$_[0] is not a LWP::UserAgent instance" unless ref $_[0] eq 'LWP::UserAgent' },
    lazy    => 1,
    default => sub { LWP::UserAgent->new },
);

1;  # End of Regru::API::Role::UserAgent

__END__

=pod

=head1 SYNOPSIS

    package Regru::API::Client;
    ...
    with 'Regru::API::Role::UserAgent';

=head1 DESCRIPTION

...

=attr useragent

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<LWP::UserAgent>

=cut
