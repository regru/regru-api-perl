package Regru::API::NamespaceHandler;

use Modern::Perl;
use Data::Dumper;

use Moo;
use URI::Encode 'uri_encode';
use List::MoreUtils 'any';
use Carp;
use Regru::API::Response;
use JSON::XS;
use URI;

use Memoize;
memoize('get_ua');
memoize('get_json');

has 'methods' => (
    is  => 'ro',
    isa => sub {
        my $self = shift;
        croak "Type of methods is ARRAY" unless ref $self eq 'ARRAY';
    }
);
has 'namespace' => ( is => 'ro', default => sub {q{}} );
has [ 'username', 'password', 'io_encoding', 'lang', 'debug' ] =>
    ( is => 'ro' );

sub BUILD {
    my $self = shift;

    {
        no strict 'refs';
        no warnings 'redefine';
        for my $method ( @{ $self->methods } ) {
            my $sub_name = ref($self) . '::' . $method;
            *{$sub_name} = sub {
                my $self = shift;

                return $self->_api_call( $method, @_ );
                }
        }
        use warnings;
    }
}

my $api_url = "http://localhost:3000/api/regru2/";
# my $api_url = "https://api.reg.ru/api/regru2/";

=head1 NAME

    Regru::API::NamespaceHandler - parent handler for all categories handlers.
Does API call and debug logging.

=cut

=head1 New namespace handler creation

First create new namespace handler package:

    package Regru::API::Domain; # must be Regru::API::ucfirst($namespace_name)
    use Modern::Perl;

    use Moo;
    extends 'Regru::API::NamespaceHandler';

    my @methods = qw/nop get_prices get_suggest/; # API calls list

    has '+methods' => (is => 'ro', default => sub { \@methods } );
    has '+namespace' => (default => sub { 'domain' }); # API namespace

    1;

And then add new namespace to @namespaces var in Regru::API

    my @namespaces = qw/user domain/;

=cut


sub _debug_log {
    my $self    = shift;
    my $message = shift;

    warn $message if $self->debug;
}

sub _api_call {
    my $self   = shift;
    my $method = shift;
    my %params = @_;

    my $ua        = $self->get_ua;
    my $namespace = $self->namespace;
    my $url       = $api_url . $namespace;
    $url .= '/' if $namespace;
    $url .= $method . '?';

    my %post_params = (
        username      => $self->username,
        password      => $self->password,
        output_format => 'json',
        input_format => 'json'
    );
    $post_params{ lang } = $self->lang if defined $self->lang;
    $post_params{ io_encoding } = $self->io_encoding if defined $self->io_encoding;


    $self->_debug_log(
        "API call: $namespace/$method, params: " . Dumper( \%params ) );

    $self->_debug_log("URI called: $url");

    my $json = $self->get_json->encode(\%params);

    my $response = $ua->post($url, [%post_params, input_data => $json]);

    return Regru::API::Response->new(response => $response);
    # if ( $response->is_success ) {
    #     my $raw_content = $response->decoded_content;
    #     $self->_debug_log( "Raw content: " . $raw_content );
    #     my $api_response
    #         = Regru::API::Response->new( raw_content => $raw_content );
    #     return $api_response;
    # }
    # else {        
    #     return Regru::API::Response->new(is_success => 0, service_answer => $response->status_line)
    #     # die Dumper $response;
    #     # croak "Not implemented yet.";
    # }
}

sub get_ua {
    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    return $ua;
}



sub get_json {
    my $self = shift;

    return JSON::XS->new->utf8;
}

1;
