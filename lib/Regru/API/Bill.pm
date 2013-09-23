package Regru::API::Bill;

# ABSTRACT: REG.API v2 "bill" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
    default => sub { 'bill' },
);

sub available_methods {[qw(
    nop
    get_not_payed
    get_for_period
    change_pay_type
    delete
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Bill

__END__

=pod

=head1 DESCRIPTION

REG.API invoices management section.

=method nop

For testing purposes. Scope: B<clients>. Typical usage:

    $resp = $client->bill->nop(
        bill_id => 12345
    );

    # or
    $resp = $client->bill->nop(
        bills => [ 12345, 12346 ]
    );

Returns payment status for requested invoice or error code (in some cases).

More info at L<Invoice management: nop|https://www.reg.com/support/help/API-version2#bill_nop>.

=method get_not_payed

Obtains a list of unpaid invoices. Scope: B<clients>. Typical usage:

    $resp = $client->bill->get_not_payed(
        limit => 10, offset => 40
    );

Returns a list of unpaind invoices if any.

More info at L<Invoice management: get_not_payed|https://www.reg.com/support/help/API-version2#bill_get_not_payed>.

=method get_for_period

Obtains a list of invoices for the defined period. Scope: B<partners>. Typical usage:

    $resp = $client->bill->get_for_period(
        limit      => 5,
        start_date => '1917-10-26',
        end_date   => '1917-10-07',
    );

Returns a list of invoices at given period if any.

More info at L<Invoice management: get_for_period|https://www.reg.com/support/help/API-version2#bill_get_for_period>

=method change_pay_type

This one allows to change payment method for selected invoice(s). Scope: B<clients>. Typical usage:

    $resp = $client->bill->change_pay_type(
        bills    => [ 12345, 12346 ],
        pay_type => 'prepay',
        currency => 'USD',
    );

Returns a list of invoices with payment information and status.

More info at L<Invoice management: change_pay_type|https://www.reg.com/support/help/API-version2#bill_change_pay_type>

=method delete

Allows to delete unpaid invoices. Scope: B<clients>. Typical usage:

    $resp = $client->bill->delete(
        bills => [ 12345, 12346, 12347 ]
    );

Returns a list of invoices which requested to delete and its status.

More info at L<Invoice management: delete|https://www.reg.com/support/help/API-version2#bill_delete>

=attr namespace

Always returns the name of category: C<bill>. For internal usage only.

=head1 CAVEATS

Bear in mind that might be errors during API requests. You should always check API call status.
See L<Common error codes|https://www.reg.com/support/help/API-version2#std_error_codes>.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Invoice management|https://www.reg.com/support/help/API-version2#bill_fn>

L<REG.API Common error codes|https://www.reg.com/support/help/API-version2#std_error_codes>.

=cut
