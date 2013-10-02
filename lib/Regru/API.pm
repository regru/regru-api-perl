package Regru::API;

# ABSTRACT: Perl bindings for Reg.ru API v2

use strict;
use warnings;
use Moo;
use Carp ();
use Class::Load qw(try_load_class);
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

sub available_methods {[qw(
    nop
    reseller_nop
    get_user_id
    get_service_id
)]}

sub available_namespaces {[qw(
    user
    domain
    zone
    bill
    folder
    service
)]}

sub _get_namespace_handler {
    my $self      = shift;
    my $namespace = shift;

    unless ( $self->{_handlers}->{$namespace} ) {
        my $ns = 'Regru::API::' . ucfirst($namespace);

        try_load_class $ns or Carp::croak 'Unable to load namespace: ' . $ns;

        my %params =
            map { $_ => $self->$_ }
                qw/username password io_encoding lang debug/;
        $self->{_handlers}->{$namespace} = $ns->new(@_, %params);
    }

    return $self->{_handlers}->{$namespace};
}

sub namespace_handlers {
    my $class = shift;

    my $meta = $class->meta;

    foreach my $namespace ( @{ $class->available_namespaces } ) {
        $namespace = lc $namespace;
        $namespace =~ s/\s/_/g;

        my $handler = sub {
            my ($self, @args) = @_;
            $self->_get_namespace_handler($namespace => @args);
        };

        $meta->add_method($namespace => $handler);
    }
}

__PACKAGE__->namespace_handlers;
__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API

__END__

=pod

=head1 SYNOPSIS

    my $client = Regru::API->new(
        username => 'test',
        password => 'test',
    );

    # trivial API request
    my $resp = $client->nop;

    if ($resp->is_success) {
        print $response->get('user_id');
    }
    else {
        print "Error code: " . $resp->error_code . ", Error text: " . $resp->error_text;
    }

=head1 DESCRIPTION

...

=head1 OVERVIEW

=head2 Categories (namespaces)

REG.API methods are divided into categories (namespaces). When you wish to make an API request to some REG.API method,
that belongs to some namespace (category) you should get a namespace handler (defined as trivial client's method):

    # suppose we already have a client
    $client->user->nop;

    # or like this
    $zone = $client->zone;
    $zone->register_ns(...);

At the moment there are the following namespaces:

=over

=item B<root>

General purpose methods such as L</nop>, L</reseller_nop> etc which are described below. Actually is a virtual namespace
defined by client. No needs to get namespace handler. The methods of this C<namespace> are available as client's methods
directly.

    $client->nop;
    $client->reseller_nop;

See details below.

=item B<user>

User account management methods.

    # suppose we already have a client
    $client->user->nop;

See L<Regru::API::User> for details and
L<REG.API Account management functions|https://www.reg.com/support/help/API-version2#user_fn>.

=item B<domain>

Domain names management methods.

    # suppose we already have a client
    $client->domain->get_nss(
        domain_name => 'gallifrey.ru',
    );

See L<Regru::API::Domain> for details and
L<REG.API Domain management functions|https://www.reg.com/support/help/API-version2#domain_fn>.

=item B<zone>

DNS resource records management methods.

    # suppose we already have a client
    $client->zone->clear(
        domain_name => 'pyrovilia.net',
    );

See L<Regru::API::Zone> for details and
L<REG.API DNS management functions|https://www.reg.com/support/help/API-version2#zone_fn>.

=item B<service>

Service management methods.

    # suppose we already have a client
    $client->service->delete(
        domain_name => 'sontar.com',
        servtype    => 'srv_hosting_plesk',
    );

See L<Regru::API::Service> for details and
L<REG.API Service management functions|https://www.reg.com/support/help/API-version2#service_fn>.

=item B<folder>

User folders management methods.

    # suppose we already have a client
    $client->folder->create(
        folder_name => 'UNIT',
    );

See L<Regru::API::Folder> for details and
L<REG.API Folder management functions|https://www.reg.com/support/help/API-version2#folder_fn>.

=item B<bill>

Invoice management methods.

    # suppose we already have a client
    $client->invoice->get_not_payed(
        limit => 10,
    );

See L<Regru::API::Bill> for details and
L<REG.API Invoice management functions|https://www.reg.com/support/help/API-version2#bill_fn>.

=back

=head2 Methods accesibility

All REG.API methods can be divided into categories of accessibility. On manual pages of this distibution accessibility
marked by C<scope> tag. At the moment the following categories of accessibility present:

=over

=item B<everyone>

All methods tagged by this one are accessible to all users. Those methods does not require authentication before call.

=item B<clients>

This tag indicates the methods which accessible only for users registered on L<reg.com|https://www.reg.com> website.
Strongly required an authenticated API request.

=item B<partners>

Group of methods which accessible only for partners (resellers) of the REG.RU LLC. Actually, partners (resellers)
able to execute all methods of the REG.API without any restrictions.

=back

=method new

Creates a client instance to interract with REG.API.

    my $client = Regru::API->new(
        username => 'Rassilon',
        password => 'You die with me, Doctor!'
    );

    my $resp = $client->user->get_balance;

    print $resp->get('prepay') if $resp->is_success;

    # another cool code...

Available options:

=over

=item B<username>

Account name of the user to access to L<reg.com|https://www.reg.com> website. Required. Should be passed at instance
create time. Although it might be changed at runtime.

    my $client = Regru::API->new(username => 'Cyberman', password => 'Exterminate!');
    ...
    # at runtime
    $client->username('Dalek');

=item B<password>

Account password of the user to access to L<reg.com|https://www.reg.com> website or an alternative password for API
defined at L<Reseller settings|https://www.reg.com/reseller/details> page. Required. Should be passed at instance create time.
Although it might be changed at runtime.

    my $client = Regru::API->new(username => 'Master', password => 'Doctor');
    ...
    # at runtime
    $client->password('The-Master.');

=item B<io_encoding>

Defines encoding that will be used for data exchange between the Service and the Client. At the moment REG.API v2
supports the following encodings: I<utf8>, I<cp1251>, I<koi8-r>, I<koi8-u>, I<cp866>. Optional. Default value is B<utf8>.

    my $client = Regru::API->new(..., io_encoding => 'cp1251');
    ...
    # or at runtime
    $client->io_encoding('cp1251');

    my $resp = $client->user->create(
        user_login      => 'othertest',
        user_password   => '111',
        user_email      => 'test@test.ru',
        user_first_name => $cp1251_encoded_name
    );

=item B<lang>

Defines the language which will be used in error messages. At the moment REG.API v2 supports the following languages:
English (I<en>), Russian (I<ru>) and Thai (I<th>). Optional. Default value is B<en>.

    my $client = Regru::API->new(..., lang => 'ru');
    ...
    # or at runtime
    $client->lang('ru');

    $client->username('bogus-user');
    print $client->nop->error_text; # -> "Ошибка аутентификации по паролю"

=item B<debug>

A few messages will be printed to STDERR. Default value is B<0> (suppressed debug activity).

    my $client = Regru::API->new(..., debug => 1);
    ...
    # or at runtime
    $client->debug(1);

=back

=method namespace_handlers

Creates shortcuts to REG.API categories (namespaces). Used internally.

=method nop

For testing purposes. Scope: B<everyone>. Typical usage:

    $resp = $client->nop;

Answer will contains an user_id and login fields.

More info at L<Common functions: nop|https://www.reg.com/support/help/API-version2#nop>.

=method reseller_nop

Similar to previous one but only for partners. Scope: B<partners>. Typical usage:

    $resp = $client->reseller_nop;

Answer will contains an user_id and login fields.

More info at L<Common functions: nop|https://www.reg.com/support/help/API-version2#reseller_nop>.

=method get_user_id

Get the identifier of the current user. Scope: B<clients>. Typical usage:

    $resp = $client->get_user_id;

Answer will contains an user_id field.

More info at L<Common functions: nop|https://www.reg.com/support/help/API-version2#get_user_id>.

=method get_service_id

Get service or domain name identifier by its name. Scope: B<clients>. Typical usage:

    $resp = $client->get_service_id(
        domain_name => 'teselecta.ru',
    );

Answer will contains a service_id field or error code if requested domain name/service not found.

More info at L<Common functions: nop|https://www.reg.com/support/help/API-version2#get_service_id>.

=head1 Error processing

If API returned exception or some bad error, such as 500 internal server error has happened,
C<$response> will store error information and raw L<HTTP::Response> object with service answer.

=head2 is_success

Returns 1 if API call is succeeded, 0 otherwise.

=head2 error_text

Returns error text if an error occured, default language for error messages is english.
Language can be set in Regru::API constructor with C<lang> option.

=head2 error_code

Returns error code if an error occured. Full list error codes list is available at L<https://www.reg.com/support/help/API-version2#std_error_codes>.
Error code API_FAIL means incorrect answer from API, such as 500 internal server error.

=head2 error_params

Params for error text.

=head2 response

Returns raw L<HTTP::Response> object for further processing.

Sample:

    my $response = $client->api->nop;
    if ($response->is_success) {
        # do some stuff
    }
    else {
        print "Error: " . $response->error_code . ", " . $response->error_text;
    }

=head1 SEE ALSO

L<Regru::API::Bill>

L<Regru::API::Domain>

L<Regru::API::Folder>

L<Regru::API::Service>

L<Regru::API::User>

L<Regru::API::Zone>

L<Regru::API::Response>

=cut
