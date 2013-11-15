package Regru::API::Hosting;

# ABSTRACT: REG.API v2 hosting management functions

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    default => sub { 'hosting' },
);

sub available_methods {[qw(
    nop
    get_jelastic_refill_url
    set_jelastic_refill_url
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Hosting

__END__

=pod

=head1 DESCRIPTION

REG.API hosting management. Only two functions are available for now, for Jelastic resellers.

=apimethod nop

For testing purposes. Scope: B<everyone>. Typical usage:

    $resp = $client->hosting->nop;

Returns success response.

More info at L<Hosting management: nop|https://www.reg.com/support/help/API-version2#hosting_nop>.

=apimethod set_jelastic_refill_url

Update Jelastic refill URL for current reseller. That url is used when client hits "Refill" button at his Jelastic account page. Keywords C<< <service_id> >> and C<< <email> >> in url will be replaced
with service identifier and user email, which was used for Jelastic account registration.
Scope B<partners>.

Typical usage:

    $resp = $client->hosting->set_jelastic_refill_url(
        url => 'http://mysite.com?service_id=<service_id>&email=<email>'
    );

Returns success response if URL was set.
More info at L<Hosting management: set_jelastic_refill_url|https://www.reg.com/support/help/API-version2#hosting_set_jelastic_refill_url>.

=apimethod get_jelastic_refill_url

Fetch Jelastic refill URL for current reseller.Scope: B<partners>. Typical usage:

    $resp = $client->hosting->get_jelastic_refill_url;

Answer will contain the url field, with reseller refill url.

More info at L<Hosting management: get_jelastic_refill_url|https://www.reg.com/support/help/API-version2#hosting_get_jelastic_refill_url>.

=attr namespace

Always returns the name of category: C<hosting>. For internal uses only.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<REG.API Hosting management|https://www.reg.com/support/help/API-version2#hosting_fn>

L<REG.API Common error codes|https://www.reg.com/support/help/API-version2#std_error_codes>.

=cut
