package Regru::API::Role::UserAgent;

# ABSTRACT: something that can act as user-agent

use strict;
use warnings;
use Moo::Role;
use LWP::UserAgent;
use Carp;
use namespace::autoclean;

# VERSION
# AUTHORITY

has useragent => (
    is      => 'rw',
    isa     => sub { croak "$_[0] is not a LWP::UserAgent instance" unless ref $_[0] eq 'LWP::UserAgent' },
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
    ...
    $resp = $self->useragent->get('http://example.com/');

    if ($resp->is_success) {
        print $resp->decoded_content;
    }
    else {
        die $resp->status_line;
    }

=head1 DESCRIPTION

Any class or role that consumes this one will able to dispatch HTTP requests.

=attr useragent

Returns an L<LWP::UserAgent> instance.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<LWP::UserAgent>

=cut
