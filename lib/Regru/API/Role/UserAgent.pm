package Regru::API::Role::UserAgent;

# ABSTRACT: Reg.ru API "user agent" role

use strict;
use warnings;
use Moo::Role;
use LWP::UserAgent;
use Carp ();

has useragent => (
    is      => 'rw',
    isa     => sub { Carp::croak "$_[0] is not a LWP::UserAgent instance" unless ref $_[0] eq 'LWP::UserAgent' },
    lazy    => 1,
    default => sub { LWP::UserAgent->new },
);

1;  # End of Regru::API::Role::UserAgent

__END__

=pod

=head1 NAME

Regru::API::Role::UserAgent - Reg.ru API "user agent" role

=head1 SYNOPSYS

    package Regru::API::Client;
    ...
    with 'Regru::API::Role::UserAgent';

=head1 DESCRIPTION

...

=head1 METHODS/ATTRIBUTES

=head2 useragent

...

=head1 SEE ALSO

L<Regru::API::Client>

=cut
