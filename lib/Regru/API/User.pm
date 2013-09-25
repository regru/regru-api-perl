package Regru::API::User;

# ABSTRACT: REG.API v2 "user" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    default => sub { 'user' },
);

sub available_methods {[qw(
    nop
    create
    get_statistics
    get_balance
    refill_balance
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::User

__END__

=pod

=head1 DESCRIPTION

REG.API user category... (to be described)

=method nop

Does nothing.

    my $response = $client->user->nop;

=method create

...

=method get_statistics

Returns statistics for current user.

Options:

=over

=item date_from

    start date for period, unnecessary

=item date_to

    end date for period, unnecessary

=back

    my $response = $client->user->get_statistics;
    say $response->get("costs_for_period") if $response->is_success;

=method get_balance

Returns balance for current user.

    my $currency = 'UAH';
    my $response = $client->user->get_balance(currency => $currency);
    say "Balance: " . $response->get("prepay") . " ". $currency if $response->is_success;

Options:

=over

=item currency

    currency for output sum, RUR by default.

=back

=method refill_balance

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
