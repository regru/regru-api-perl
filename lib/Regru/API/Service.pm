package Regru::API::Service;

# ABSTRACT: REG.API v2 "service" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
    default => sub { 'service' },
);

sub available_methods {[qw(
    nop
    get_prices
    get_servtype_details
    create
    delete
    get_info
    get_list
    get_folders
    get_details
    service_get_details
    get_dedicated_server_list
    update
    renew
    get_bills
    set_autorenew_flag
    suspend
    resume
    get_depreciated_period
    upgrade partcontrol_grant
    partcontrol_revoke
    resend_mail
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Service

__END__

=pod

=head1 DESCRIPTION

REG.API service category... (to be described)

=method nop

...

=method get_prices

...

=method get_servtype_details

...

=method create

...

=method delete

...

=method get_info

...

=method get_list

...

=method get_folders

...

=method get_details

...

=method service_get_details

...

=method get_dedicated_server_list

...

=method update

...

=method renew

...

=method get_bills

...

=method set_autorenew_flag

...

=method suspend

...

=method resume

...

=method get_depreciated_period

...

=method upgrade partcontrol_grant

...

=method partcontrol_revoke

...

=method resend_mail

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
