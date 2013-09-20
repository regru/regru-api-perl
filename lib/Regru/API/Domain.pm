package Regru::API::Domain;

# ABSTRACT: REG.API v2 "domain" category methods

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
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
