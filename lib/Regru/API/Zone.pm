package Regru::API::Zone;

use Modern::Perl;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods
    = qw/nop add_alias add_aaaa add_cname add_mx add_ns add_txt
    add_srv get_resource_records update_records update_soa 
    tune_forwarding clear_forwarding tune_parking clear_parking remove_record clear/;

has '+methods' => ( is => 'ro', default => sub { \@methods } );
has '+namespace' => ( default => sub {'zone'} );

1;