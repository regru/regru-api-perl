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

=apimethod nop

...

=apimethod add_alias

...

=apimethod add_aaaa

...

=apimethod add_cname

...

=apimethod add_mx

...

=apimethod add_ns

...

=apimethod add_txt

...

=apimethod add_srv

...

=apimethod get_resource_records

...

=apimethod update_records

...

=apimethod update_soa

...

=apimethod tune_forwarding

...

=apimethod clear_forwarding

...

=apimethod tune_parking

...

=apimethod clear_parking

...

=apimethod remove_record

...

=apimethod clear

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
