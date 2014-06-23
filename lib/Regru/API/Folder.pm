package Regru::API::Folder;

# ABSTRACT: REG.API v2 user folders management

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
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

REG.API folders management methods such as create/remove/rename folders, get/put services linked to and others.

=apimethod nop

For testing purposes. Scope: B<everyone>. Typical usage:

    $resp = $client->folder->nop(
        folder_name => 'our_folder',
    );

Returns success response.

More info at L<Folder management: nop|https://www.reg.com/support/help/api2#folder_nop>.

=apimethod create

Creates a folder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->create(
        folder_name => 'vehicles',
    );

Returns success response if folder was created or error otherwise.

More info at L<Folder management: create|https://www.reg.com/support/help/api2#folder_create>.

=apimethod remove

Deletes an existing folder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->remove(
        folder_id => 674908,
    );

Returns success response if folder was deleted or error otherwise.

More info at L<Folder management: remove|https://www.reg.com/support/help/api2#folder_remove>.

=apimethod rename

Renames an existing forder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->rename(
        folder_name     => 'stuff',
        new_folder_name => 'items',
    );

Returns success response if folder was renamed or error otherwise.

More info at L<Folder management: rename|https://www.reg.com/support/help/api2#folder_rename>.

=apimethod get_services

Gets services linked to folder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->get_services(
        folder_id => 389765,
    );

A success answer will contains a C<folder_content> with a list of services (domain names, hosting related items, etc) linked
to requested folder.

More info at L<Folder management: get_services|https://www.reg.com/support/help/api2#folder_get_services>.

=apimethod add_services

"Puts" services to folder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->add_services(
        folder_name => 'vehicles',
        services => [
            { domain_name => 'crucible.co.uk' },
            { domain_name => 'ss-madame-de-pompadour.ru' },
        ],
        return_folder_contents => 1,
    );

A successful answer will contains a C<services> field with a list of services that was linked to the specified folder
and result for each of them. Additionally might be returned a C<folder_content> field.

More info at L<Folder management: add_services|https://www.reg.com/support/help/api2#folder_add_services>.

=apimethod remove_services

"Deletes" services from folder. Scope: B<clients>. Typical usage:

    $resp = $client->folder->remove_services(
        folder_name => 'vehicles',
        services => [
            { domain_name => 'bow-tie.com' },
        ],
    );

A successful answer will contains a C<services> field with a list of services that was unlinked to the specified folder
and result for each of them. Additionally might be returned a C<folder_content> field.

More info at L<Folder management: remove_services|https://www.reg.com/support/help/api2#folder_remove_services>.

=apimethod replace_services

"Replaces" services with a new set of services. Scope: B<clients>. Typical usage:

    $resp = $client->folder->replace_services(
        folder_name => 'items',
        services => [
            { domain_name => 'bow-tie.com' },
            { service_id => 188650 },
            { service_id => 239076 },
        ],
    );

A successful answer will contains a C<services> field with a list of services that was linked to the specified folder
and result for each of them. Additionally might be returned a C<folder_content> field.

More info at L<Folder management: replace_services|https://www.reg.com/support/help/api2#folder_replace_services>.

=apimethod move_services

"Transfers" services between folders. Scope: B<clients>. Typical usage:

    $resp = $client->folder->move_services(
        folder_name     => 'vehicles',
        new_folder_name => 'items',
        services => [
            { domain_name => 'bow-tie.cz' },
            { domain_name => 'hallucinogenic-lipstick.xxx' },
            { service_id => 783908 },
        ],
    );

A successful answer will contains a C<services> field with a list of services that was linked to the specified folder
and result for each of them. Additionally might be returned a C<folder_content> field with a contents of a destination folder.

More info at L<Folder management: move_services|https://www.reg.com/support/help/api2#folder_move_services>.

=attr namespace

Always returns the name of category: C<folder>. For internal uses only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Folders management|https://www.reg.com/support/help/api2#folder_functions>

L<REG.API Common error codes|https://www.reg.com/support/help/api2#common_errors>

=cut
