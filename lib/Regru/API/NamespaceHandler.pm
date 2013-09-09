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
memoize('_get_ua');
memoize('_get_json_xs');

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

=head1 NAME

    Regru::API::Category - parent handler for all categories handlers.
Does API call and debug logging.

=cut

=begin comment

=head2 methods

Moo getter for methods. Must return ArrayRef. Method is redefined in inherited packages, such as Regru::API::User,
and returns list  of methods for each namespace.

=head2 namespace

Moo getter for API namespace. Method is redefined in inherited packages and returns API methods namespace for each namespace handler.

=head2 username, password

Getters for authentication parameters.

=head2 io_encoding

=head2 lang

=head2 debug


=end comment


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

# use vars '$AUTOLOAD';

# sub AUTOLOAD {
#     my $self = shift;

#     my $namespace = $self->namespace;

#     # сделать запрос к АПИ
#     my $called_method = $AUTOLOAD;
#     $called_method =~ s/^.*:://;

#     if ( any { $_ eq $called_method } @{ $self->methods } ) {
#         return $self->_api_call( $namespace => $called_method, @_ );
#     }
#     else {
#         croak "API call $called_method is undefined.";
#     }
# }

# sub DESTROY { }

sub _debug_log {
    my $self    = shift;
    my $message = shift;

    warn $message if $self->debug;
}

sub _api_call {
    my $self   = shift;
    my $method = shift;
    my %params = @_;

    my $ua        = $self->_get_ua;
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

    # my $json = JSON::XS->new->utf8->encode(\%params);
    my $json = $self->_get_json_xs->encode(\%params);

    my $response = $ua->post($url, [%post_params, input_data => $json]);

    if ( $response->is_success ) {
        my $raw_content = $response->decoded_content;
        $self->_debug_log( "Raw content: " . $raw_content );
        my $api_response
            = Regru::API::Response->new( raw_content => $raw_content );
        return $api_response;
    }
    else {
        die Dumper $response;
        croak "Not implemented yet.";
    }
}

sub _get_ua {
    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    return $ua;
}



sub _get_json_xs {
    my $self = shift;

    return JSON::XS->new->utf8;
}

1;
