package Regru::API::Bill;
use Modern::Perl;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods = qw/nop get_nop_payed get_for_period change_pay_type delete/;

has '+methods' => ( is => 'ro', default => sub { \@methods } );
has '+namespace' => ( default => sub {'bill'} );

1;