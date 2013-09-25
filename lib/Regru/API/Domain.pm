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

REG.API domain category... (to be described)

=method nop

...

=method get_prices

...

=method get_suggest

...

=method get_premium

...

=method check

...

=method create

...

=method transfer

...

=method get_rereg_data

...

=method set_rereg_bids

...

=method get_user_rereg_bids

...

=method get_docs_upload_uri

...

=method update_contacts

...

=method update_private_person_flag

...

=method register_ns

...

=method delete_ns

...

=method get_nss

...

=method update_nss

...

=method delegate

...

=method undelegate

...

=method transfer_to_another_account

...

=method look_at_entering_list

...

=method accept_or_refuse_entering_list

...

=method cancel_transfer

...

=method request_to_transfer

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
