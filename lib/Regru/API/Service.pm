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

=apimethod nop

...

=apimethod get_prices

...

=apimethod get_servtype_details

...

=apimethod create

...

=apimethod delete

...

=apimethod get_info

...

=apimethod get_list

...

=apimethod get_folders

...

=apimethod get_details

...

=apimethod service_get_details

...

=apimethod get_dedicated_server_list

...

=apimethod update

...

=apimethod renew

...

=apimethod get_bills

...

=apimethod set_autorenew_flag

...

=apimethod suspend

...

=apimethod resume

...

=apimethod get_depreciated_period

...

=apimethod upgrade partcontrol_grant

...

=apimethod partcontrol_revoke

...

=apimethod resend_mail

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
