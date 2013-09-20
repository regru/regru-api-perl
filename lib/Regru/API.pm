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

# XXX необходимо полность переписать этот pod

=pod

=head1 SYNOPSIS

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop; # makes call for <https://www.reg.com/support/help/API-version2#nop>

    if ($response->is_success) {
        say $response->get('user_id');
    }
    else {
        die "Error code: " . $response->error_code . ", Error text: " . $response->error_text;
    }

=head1 DESCRIPTION

API calls are divided into categories - user, domain, zone, user, folder, bill, service.
Each category is stored in it's own namespace, and can be accessed through
C<< $client->$namespace method >>. For example,

    $client->user->nop

makes call to user/nop API method L<https://www.reg.com/support/help/API-version2#user_nop>

Complete Reg.ru API 2 Documentation can be found here: L<https://www.reg.com/support/help/API-version2>.

All API methods return L<Regru::API::Response> object.

    my $response = $client->domain->get_premium;

    if ($response->is_success) {
        # answer params can be get with C<$response->get($param_name)> method
        my $domains = $response->get('domain');
        for my $domain_info (@$domains) {
            say "Name: " . $domain_info->{ name } . ", price: " . $domain_info->{ price };
        }
    }
    else {
        ...
    }


All params for API call is passed to API method call as a hash;

    my $refill_balance_response = $client->user->refill_balance(
        pay_type => 'WM',
        wmid     => '123456789012',
        currency => 'RUR',
        amount   => 100
    );

    my $jsondata = {
        contacts => {
            descr    => 'Vschizh site',
            person   => 'Svyatoslav V Ryurik',
            person_r => 'Рюрик Святослав Владимирович',
            passport =>
                '22 44 668800 выдан по месту правления 01.09.1164',
            birth_date => '01.01.1970',
            p_addr =>
                '12345, г. Вщиж, ул. Княжеска, д.1, Рюрику Святославу Владимировичу, князю Вщижскому',
            phone   => '+7 495 5555555',
            e_mail  => 'test@reg.ru',
            country => 'RU',
        },
        nss => {
            ns0 => 'ns1.reg.ru',
            ns1 => 'ns2.reg.ru',
        },
        domain_name => 'vschizh.su',
    };

    my $domain_create_answer = $client->domain->create(%$jsondata);

    if ($domain_create_answer->is_success) {
        say "Domain create request succeeded";
    }
    else {
        die $domain_create_answer->error_text;
    }

B<NB>: All input params for call are passed in JSON format.

To get service answer, use C<< $response->get($param_name) >> method. C<$param_name> is the answer field.

=method new

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop;
    # another cool code here...

    # and without authentication:
    my $client = Regru::API->new;

    my $response = $client->user->nop; # user/nop doesn't require authentication
    say 'ok' if $response->is_success;

Another options for new():

=over

=item lang

Sets language for error messages.

    my $client = Regru::API->new(username => 'test1', password => 'test', lang => 'ru');
    print $client->nop->error_text; # will print "Ошибка аутентификации по паролю"

=item io_encoding

Sets encoding for input and output data.

    my $client = Regru::API->new(
        username    => 'test',
        password    => 'test',
        io_encoding => 'cp1251'
    );
    my $response = $client->user->create(
        user_login      => 'othertest',
        user_password   => '111',
        user_email      => 'test@test.ru',
        user_first_name => $cp1251_encoded_name
    );

=item debug

Debug messages will be printed to STDERR.

    my $client = Regru::API->new(debug => 1);

=back

=method namespace_handlers

...

=method nop

...

=method reseller_nop

...

=method get_user_id

...

=method get_service_id

...

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
