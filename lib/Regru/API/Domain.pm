package Regru::API::Domain;
use strict;
use warnings;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods = qw/nop get_prices get_suggest get_premium
    check create transfer get_rereg_data set_rereg_bids
    get_user_rereg_bids get_docs_upload_uri update_contacts
    update_private_person_flag register_ns delete_ns get_nss
    update_nss delegate undelegate transfer_to_another_account
    look_at_entering_list accept_or_refuse_entering_list cancel_transfer
    request_to_transfer/;

has '+namespace' => ( default => sub {'domain'} );

sub methods { \@methods };

__PACKAGE__->_create_methods;


1;
