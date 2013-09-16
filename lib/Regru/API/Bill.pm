package Regru::API::Bill;
use strict;
use warnings;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods = qw/nop get_not_payed get_for_period change_pay_type delete/;

has '+namespace' => ( default => sub {'bill'} );

sub methods { \@methods };

__PACKAGE__->_create_methods;


1;