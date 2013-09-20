package Regru::API::Bill;

# ABSTRACT: REG.API v2 "bill" category methods

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
