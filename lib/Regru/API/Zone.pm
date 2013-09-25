package Regru::API::Zone;

# ABSTRACT: REG.API v2 "zone" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
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

=pod

=head1 DESCRIPTION

REG.API zone category... (to be described)

=method nop

...

=method add_alias

...

=method add_aaaa

...

=method add_cname

...

=method add_mx

...

=method add_ns

...

=method add_txt

...

=method add_srv

...

=method get_resource_records

...

=method update_records

...

=method update_soa

...

=method tune_forwarding

...

=method clear_forwarding

...

=method tune_parking

...

=method clear_parking

...

=method remove_record

...

=method clear

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
