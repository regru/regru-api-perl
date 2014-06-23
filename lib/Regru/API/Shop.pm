package Regru::API::Shop;

# ABSTRACT: REG.API v2 domain shop management functions

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    default => sub { 'shop' },
);

sub available_methods {[qw(
    nop
    add_lot
    update_lot
    delete_lot
    get_info
    get_lot_list
    get_category_list
    get_suggested_tags
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Shop

__END__

=pod

=head1 DESCRIPTION

REG.API domain shop management.

=apimethod nop

For testing purposes. Scope: B<clients>. Typical usage:

    $resp = $client->shop->nop;

Returns success response.

More info at L<Shop management: nop|https://www.reg.com/support/help/api2#shop_nop>.

=apimethod add_lot

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->add_lot(

    );

Returns..

More info at L<Shop management: add_lot|https://www.reg.com/support/help/api2#shop_add_lot>.

=apimethod update_lot

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->update_lot(

    );

Returns..

More info at L<Shop management: update_lot|https://www.reg.com/support/help/api2#shop_update_lot>.

=apimethod delete_lot

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->delete_lot(

    );

Returns..

More info at L<Shop management: delete_lot|https://www.reg.com/support/help/api2#shop_delete_lot>.

=apimethod get_info

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->get_info(

    );

Returns..

More info at L<Shop management: get_info|https://www.reg.com/support/help/api2#shop_get_info>.

=apimethod get_lot_list

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->get_lot_list(

    );

Returns..

More info at L<Shop management: |https://www.reg.com/support/help/api2#shop_get_lot_list>.

=apimethod get_category_list

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->get_category_list(

    );

Returns..

More info at L<Shop management: get_category_list|https://www.reg.com/support/help/api2#shop_get_category_list>.

=apimethod get_suggested_tags

...

Scope B<clients>. Typical usage:

    $resp = $client->shop->get_suggested_tags(

    );

Returns..

More info at L<Shop management: get_suggested_tags|https://www.reg.com/support/help/api2#shop_get_suggested_tags>.

=attr namespace

Always returns the name of category: C<shop>. For internal uses only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Domain shop management|https://www.reg.com/support/help/api2#shop_functions>

L<REG.API Common error codes|https://www.reg.com/support/help/api2#common_errors>

=cut
