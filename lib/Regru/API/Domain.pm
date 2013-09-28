package Regru::API::Domain;

# ABSTRACT: REG.API v2 "domain" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    default => sub { 'domain' },
);

sub available_methods {[qw(
    nop
    get_prices
    get_suggest
    get_premium
    check
    create
    transfer
    get_rereg_data
    set_rereg_bids
    get_user_rereg_bids
    get_docs_upload_uri
    update_contacts
    update_private_person_flag
    register_ns
    delete_ns
    get_nss
    update_nss
    delegate
    undelegate
    transfer_to_another_account
    look_at_entering_list
    accept_or_refuse_entering_list
    cancel_transfer
    request_to_transfer
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Domain

__END__

=pod

=head1 DESCRIPTION

REG.API domain names management methods such as applying registration, initiating transfer to REG.RU, update administrative
contacts, placing bids on freeing domain names, retrive/update DNS servers for domain and many others.

=method nop

For testing purposes. Scope: B<everyone>. Typical usage:

    $resp = $client->domain->nop(
        dname => 'sonic-screwdriver.com'
    );

Returns success response.

More info at L<Domain management: nop|https://www.reg.com/support/help/API-version2#domain_nop>.

=method get_prices

Get prices for domain registration/renewal in all available zones. Scope: B<everyone>. Typical usage:

    $resp = $client->domain->get_prices;

    # or
    $resp = $client->domain->get_prices(
        currency => 'USD'
    );

Additional options might be passed to this method. Returns a list available zones and cost of domain registration/renewal
onto the minimal required term.

More info at L<Domain management: get_prices|https://www.reg.com/support/help/API-version2#domain_get_prices>.

=method get_suggest

Gets the domain names suggestions for given word or two (as additional parameter). Scope: B<partners>. Typical usage:

    $resp = $client->domain->get_suggest(
        word => 'teselecta',
        tlds => 'ru',
        tlds => 'com',
    );

Returns a list of alternatives and its availability in given zones. Result set is limited to I<100> items.

More info at L<Domain management: get_suggest|https://www.reg.com/support/help/API-version2#domain_get_suggest>.

=method get_premium

Gets a list of the premium domains available for registration. Scope: B<partners>. Typical usage:

    $resp = $client->domain->get_premium(
        tld     => 'ru',     # default zone
        tld     => 'orgcyr', # IDN @ .ORG
        limit   => 10,
    );

Answer contains a list each element of it contains premium domain name and its price.

More info at L<Domain management: get_premium|https://www.reg.com/support/help/API-version2#domain_get_premium>.

=method check

Use this method to check availability of a domain name for registration. Scope: B<partners>. Typical usage:

    $resp = $client->domain->check(
        domain_name => 'trenzalore.net'
    );

    # or
    $resp = $client->domain->check(
        domains => [
            { dname => 'apalapucia.com' },
            { dname => 'gallifrey.ru' },
        ]
    );

Response answer contains C<domains> field with list of hashes providing information about domain names and their
availability or error code.

More info at L<Domain management: check|https://www.reg.com/support/help/API-version2#domain_check>.

=method create

Apply for domain name registration. Scope: B<clients>. Typical usage:

    $resp = $client->domain->check(
        domain_name => 'messaline.ru',
        contacts => {
            # set of contact fields goes here (depends on zone)
            ...
        },
        nss => {
            ns0     => 'ns1.messaline.ru',
            ns0ip   => '172.16.10.1',       # The glue record for the name server at the same domain
            ns1     => 'ns2.messaline.com',
        }
    );

Successful response will contains a list of domains and billing information.

More info at L<Domain management: create|https://www.reg.com/support/help/API-version2#domain_create>.

=method transfer

Apply for a transfer of a domain name from foreign registrar. Scope: B<clients>. Typical usage:

    $resp = $client->domain->transfer(
        authinfo    => 'f8gL-rGi/*8_VB',
        domain_name => 'midnight.net',
    );

This method has request fields similar to L<#create> method call. For the most part of the international zones such as
C<.com>, C<.net>, C<.org> should be provided transfer key by specifying parameter authinfo.

More info at L<Domain management: transfer|https://www.reg.com/support/help/API-version2#domain_transfer>.

=method get_rereg_data

Gets a list of freeing domain names and their details. Scope: B<partners>. Typical usage:

    $resp = $client->domain->get_rereg_data(
        min_pr      => 2,
        max_chars   => 5,
        sort        => 'price',
    );

Returns a domain names list for the given parameters.

More info at L<Domain management: get_rereg_data|https://www.reg.com/support/help/API-version2#domain_get_rereg_data>.

=method set_rereg_bids

Places a bid or bids for the freeing domain names. Scope: B<clients>. Typical usage:

    $resp = $client->domain->set_rereg_bids(
        contacts => {
            # similar to apply domain name registration
            ...
        },
        nss => {
            # this one too
            ...
        },
        domains => [
            { dname => 'pyrovilia.su', price => 400 },
            { dname => 'saturnyne.ru', price => 225 },
        ],
    );

Answer will be contains a list of domain names and their bid status. Additionally a payment status for the placed
bids will be returned.

More info at L<Domain management: set_rereg_bids|https://www.reg.com/support/help/API-version2#domain_set_rereg_bids>.

=method get_user_rereg_bids

Gets the bids placed on. Scope: B<clients>. Typical usage:

    $resp = $client->domain->get_user_rereg_bids;

Returns a list of a domain names for which user has placed bids on.

More info at L<Domain management: get_user_rereg_bids|https://www.reg.com/support/help/API-version2#domain_get_user_rereg_bids>.

=method get_docs_upload_uri

Gets a link for uploading registrant identification documents (only for B<.RU>, B<.SU> and B<.РФ> zones).
Scope: B<clients>. Typical usage:

    $resp = $client->domain->get_docs_upload_uri(
        dname => 'test.ru'
    );

Answer will be contains an url that should be used to upload documents.

More info at L<Domain management: get_docs_upload_uri|https://www.reg.com/support/help/API-version2#domain_get_docs_upload_uri>.

=method update_contacts

... Scope: B<clients>. Typical usage:

More info at L<Domain management: update_contacts|https://www.reg.com/support/help/API-version2#domain_update_contacts>.

=method update_private_person_flag

... Scope: B<clients>. Typical usage:

More info at L<Domain management: update_private_person_flag|https://www.reg.com/support/help/API-version2#domain_update_private_person_flag>.

=method register_ns

... Scope: B<clients>. Typical usage:

More info at L<Domain management: register_ns|https://www.reg.com/support/help/API-version2#domain_register_ns>.

=method delete_ns

... Scope: B<clients>. Typical usage:

More info at L<Domain management: delete_ns|https://www.reg.com/support/help/API-version2#domain_delete_ns>.

=method get_nss

... Scope: B<clients>. Typical usage:

More info at L<Domain management: get_nss|https://www.reg.com/support/help/API-version2#domain_get_nss>.

=method update_nss

... Scope: B<clients>. Typical usage:

More info at L<Domain management: update_nss|https://www.reg.com/support/help/API-version2#domain_update_nss>.

=method delegate

... Scope: B<partners>. Typical usage:

More info at L<Domain management: delegate|https://www.reg.com/support/help/API-version2#domain_delegate>.

=method undelegate

... Scope: B<partners>. Typical usage:

More info at L<Domain management: undelegate|https://www.reg.com/support/help/API-version2#domain_undelegate>.

=method transfer_to_another_account

... Scope: B<partners>. Typical usage:

More info at L<Domain management: transfer_to_another_account|https://www.reg.com/support/help/API-version2#domain_transfer_to_another_account>.

=method look_at_entering_list

... Scope: B<partners>. Typical usage:

More info at L<Domain management: look_at_entering_list|https://www.reg.com/support/help/API-version2#domain_look_at_entering_list>.

=method accept_or_refuse_entering_list

... Scope: B<partners>. Typical usage:

More info at L<Domain management: accept_or_refuse_entering_list|https://www.reg.com/support/help/API-version2#domain_accept_or_refuse_entering_list>.

=method cancel_transfer

... Scope: B<partners>. Typical usage:

More info at L<Domain management: cancel_transfer|https://www.reg.com/support/help/API-version2#domain_cancel_transfer>.

=method request_to_transfer

... Scope: B<partners>. Typical usage:

More info at L<Domain management: request_to_transfer|https://www.reg.com/support/help/API-version2#domain_request_to_transfer>.

=attr namespace

Always returns the name of category: C<domain>. For internal usage only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Domain management|https://www.reg.com/support/help/API-version2#domain_fn>

L<REG.API Common error codes|https://www.reg.com/support/help/API-version2#std_error_codes>.

=cut
