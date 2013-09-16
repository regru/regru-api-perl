package Regru::API::Folder;
use strict;
use warnings;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods
    = qw/nop create remove rename get_services add_services remove_services
    replace_services move_services/;

has '+namespace' => ( default => sub {'folder'} );

sub methods { \@methods };

__PACKAGE__->_create_methods;

1;