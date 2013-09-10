package Regru::API::Folder;

use Modern::Perl;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods
    = qw/nop create remove rename get_services add_services remove_services
    replace_services move_services/;

has '+methods' => ( is => 'ro', default => sub { \@methods } );
has '+namespace' => ( default => sub {'folder'} );

1;