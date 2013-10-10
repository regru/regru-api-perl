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

REG.API service management methods such as create/remove/suspend/resume services, get information, grant/revoke access to
a service to other users, retrieve list of invoices on service and many others.

=apimethod nop

. Scope: B<clients>. Typical usage:

    $resp = $client->service->nop(
    );

More info at L<Service management: nop|https://www.reg.com/support/help/API-version2#service_nop>.

=apimethod get_prices

. Scope: B<everyone>. Typical usage:

    $resp = $client->service->get_prices(
    );

More info at L<Service management: get_prices|https://www.reg.com/support/help/API-version2#service_get_prices>.

=apimethod get_servtype_details

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_servtype_details(
    );

More info at L<Service management: get_servtype_details|https://www.reg.com/support/help/API-version2#service_get_servtype_details>.

=apimethod create

. Scope: B<clients>. Typical usage:

    $resp = $client->service->create(
    );

More info at L<Service management: create|https://www.reg.com/support/help/API-version2#service_create>.

=apimethod delete

. Scope: B<clients>. Typical usage:

    $resp = $client->service->delete(
    );

More info at L<Service management: delete|https://www.reg.com/support/help/API-version2#service_delete>.

=apimethod get_info

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_info(
    );

More info at L<Service management: get_info|https://www.reg.com/support/help/API-version2#service_get_info>.

=apimethod get_list

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_list(
    );

More info at L<Service management: get_list|https://www.reg.com/support/help/API-version2#service_get_list>.

=apimethod get_folders

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_folders(
    );

More info at L<Service management: get_folders|https://www.reg.com/support/help/API-version2#service_get_folders>.

=apimethod get_details

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_details(
    );

More info at L<Service management: get_details|https://www.reg.com/support/help/API-version2#service_get_details>.

=apimethod service_get_details

. Scope: B<clients>. Typical usage:

    $resp = $client->service->service_get_details(
    );

More info at L<Service management: service_get_details|https://www.reg.com/support/help/API-version2#service_service_get_details>.

=apimethod get_dedicated_server_list

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_dedicated_server_list(
    );

More info at L<Service management: get_dedicated_server_list|https://www.reg.com/support/help/API-version2#service_get_dedicated_server_list>.

=apimethod update

. Scope: B<clients>. Typical usage:

    $resp = $client->service->update(
    );

More info at L<Service management: update|https://www.reg.com/support/help/API-version2#service_update>.

=apimethod renew

. Scope: B<clients>. Typical usage:

    $resp = $client->service->renew(
    );

More info at L<Service management: renew|https://www.reg.com/support/help/API-version2#service_renew>.

=apimethod get_bills

. Scope: B<partners>. Typical usage:

    $resp = $client->service->get_bills(
    );

More info at L<Service management: get_bills|https://www.reg.com/support/help/API-version2#service_get_bills>.

=apimethod set_autorenew_flag

. Scope: B<clients>. Typical usage:

    $resp = $client->service->set_autorenew_flag(
    );

More info at L<Service management: set_autorenew_flag|https://www.reg.com/support/help/API-version2#service_set_autorenew_flag>.

=apimethod suspend

. Scope: B<clients>. Typical usage:

    $resp = $client->service->suspend(
    );

More info at L<Service management: suspend|https://www.reg.com/support/help/API-version2#service_suspend>.

=apimethod resume

. Scope: B<clients>. Typical usage:

    $resp = $client->service->resume(
    );

More info at L<Service management: resume|https://www.reg.com/support/help/API-version2#service_resume>.

=apimethod get_depreciated_period

. Scope: B<clients>. Typical usage:

    $resp = $client->service->get_depreciated_period(
    );

More info at L<Service management: get_depreciated_period|https://www.reg.com/support/help/API-version2#service_get_depreciated_period>.

=apimethod upgrade

. Scope: B<clients>. Typical usage:

    $resp = $client->service->upgrade(
    );

More info at L<Service management: upgrade |https://www.reg.com/support/help/API-version2#service_upgrade>.

=apimethod partcontrol_grant

. Scope: B<clients>. Typical usage:

    $resp = $client->service->partcontrol_grant(
    );

More info at L<Service management: partcontrol_grant|https://www.reg.com/support/help/API-version2#service_partcontrol_grant>.

=apimethod partcontrol_revoke

. Scope: B<clients>. Typical usage:

    $resp = $client->service->partcontrol_revoke(
    );

More info at L<Service management: partcontrol_revoke|https://www.reg.com/support/help/API-version2#service_partcontrol_revoke>.

=apimethod resend_mail

. Scope: B<clients>. Typical usage:

    $resp = $client->service->resend_mail(
    );

More info at L<Service management: resend_mail|https://www.reg.com/support/help/API-version2#service_resend_mail>.

=attr namespace

Always returns the name of category: C<service>. For internal uses only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Service management|https://www.reg.com/support/help/API-version2#service_fn>

L<REG.API Common error codes|https://www.reg.com/support/help/API-version2#std_error_codes>.

=cut
