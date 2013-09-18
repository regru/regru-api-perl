package Regru::API::User;
use strict;
use warnings;

use Moo;
extends 'Regru::API::NamespaceHandler';


my @methods = qw/nop create get_statistics get_balance refill_balance/;
my $namespace = 'user';

has '+namespace' => (is => 'ro', default => sub { $namespace } );

sub methods { \@methods };

__PACKAGE__->_create_methods;



1;
