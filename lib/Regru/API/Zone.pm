package Regru::API::Zone;

use strict;
use warnings;
use Moo;

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
    default => sub { 'zone' },
);

sub available_methods {[qw(
    nop
    add_alias
    add_aaaa
    add_cname
    add_mx
    add_ns
    add_txt
    add_srv
    get_resource_records
    update_records
    update_soa
    tune_forwarding
    clear_forwarding
    tune_parking
    clear_parking
    remove_record
    clear
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Zone

__END__
