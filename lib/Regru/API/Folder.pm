package Regru::API::Folder;

use strict;
use warnings;
use Moo;
use namespace::autoclean;

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
    default => sub { 'folder' },
);

sub available_methods {[qw(
    nop
    create
    remove
    rename
    get_services
    add_services
    remove_services
    replace_services
    move_services
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Folder

__END__
