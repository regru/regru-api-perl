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

REG.API account management methods such as create new user, fetch some statistics and deposit funds to an account.

=apimethod nop

For testing purposes. Scope: B<everyone>. Typical usage:

    $resp = $client->user->nop;

Returns success response.

More info at L<Account management: nop|https://www.reg.com/support/help/API-version2#user_nop>.

=apimethod create

Creates a new user account. Scope: B<partners>. Typical usage:

    $resp = $client->user->create(
        # required fields
        user_login      => 'digory',
        user_password   => 'gof4iSewvy8aK5at',
        user_email      => 'digory.kirke@wardrobe.co.uk',
        user_country    => 'GB',

        # optional extra fields
        ...

        set_me_as_referer => 1,
    );

Answer will contains an C<user_id> field for newly created user account or error otherwise.

There are a lot of optional fields related to user account so check the documentation if you wish to use them.
More info at L<Account management: create|https://www.reg.com/support/help/API-version2#user_create>.

=apimethod get_statistics

Fetch usage statistic for current account. Scope: B<clients>. Typical usage:

    $resp = $client->user->get_statistics(
        date_from => '2013-01-01',
        date_till => '2013-06-30',
    );

Parameters C<date_from> and C<date_till> are optional. Answer will contains a set of metrics such as number of active
domain names, number of domain names which are subject to renewal, number of folders, etc.

More info at L<Account management: get_statistics|https://www.reg.com/support/help/API-version2#user_get_statistics>.

=apimethod get_balance

Shows a current user account balance. Scope: B<clients>. Typical usage:

    $resp = $client->user->get_balance(
        currency => 'EUR',
    );

Answer will contains a set of fields like amount of available funds, amount of a blocked funds. For resellers (partners)
will be shown amount of available credit additionally.

More info at L<Account management: get_balance|https://www.reg.com/support/help/API-version2#user_get_balance>.

=apimethod refill_balance

Tops up an user account balance with Webmoney or Yandex.Money. Scope: B<clients>. Typical usage:

    $resp = $client->user->refill_balance(
        pay_type    => 'WM',            # Webmoney
        wmid        => 291400771678,    # Webmoney ID
        currency    => 'USD',
        amount      => '19.95',
    );

Answer will contains an invoice ID and other payment details or error otherwise.

More info at L<Account management: refill_balance|https://www.reg.com/support/help/API-version2#user_refill_balance>.

=attr namespace

Always returns the name of category: C<user>. For internal uses only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
