package Regru::API::Folder;

# ABSTRACT: REG.API v2 "folder" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

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

=pod

=head1 DESCRIPTION

REG.API folder category... (to be described)

=method nop

...

=method create

...

=method remove

...

=method rename

...

=method get_services

...

=method add_services

...

=method remove_services

...

=method replace_services

...

=method move_services

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
