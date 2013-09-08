package Regru::API::Domain;
use Modern::Perl;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods = qw/nop get_prices get_suggest/;

has '+methods' => (is => 'ro', default => sub { \@methods } );
has '+namespace' => (default => sub { 'domain' });

1;