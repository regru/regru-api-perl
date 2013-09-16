package Regru::API::NamespaceHandler;
use v5.10.1;
use strict;
use warnings;
use Moo;
use List::MoreUtils 'any';
use Carp;
use Regru::API::Response;
use JSON;
use Data::Dumper;
use LWP::UserAgent;

has 'namespace' => ( is => 'ro', default => sub {q{}} );
has [ 'username', 'password', 'io_encoding', 'lang', 'debug' ] =>
    ( is => 'ro' );

has 'api_url' =>

    # ( is => 'ro', default => sub {'http://localhost:3000/api/regru2/'} );
    ( is => 'ro', default => sub {'https://api.reg.ru/api/regru2/'} );

sub _create_methods {
    my $class = shift;

    {
        no strict 'refs';
        no warnings 'redefine';
        for my $method ( @{ $class->methods } ) {
            my $sub_name = $class . '::' . $method;
            *{$sub_name} = sub {
                my $self = shift;

                return $self->_api_call( $method, @_ );
                }
        }
        use warnings;
    }
}

sub methods { croak "Absract and must be implemented" }

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
    my $url       = $self->api_url . $namespace;
    $url .= '/' if $namespace;
    $url .= $method . '?';

    my %post_params = (
        username      => $self->username,
        password      => $self->password,
        output_format => 'json',
        input_format  => 'json'
    );
    $post_params{lang} = $self->lang if defined $self->lang;
    $post_params{io_encoding} = $self->io_encoding
        if defined $self->io_encoding;

    $self->_debug_log(
        "API call: $namespace/$method, params: " . Dumper( \%params ) );

    $self->_debug_log("URI called: $url");

    my $json = $self->get_json->encode( \%params );

    my $response = $ua->post( $url, [ %post_params, input_data => $json ] );

    return Regru::API::Response->new( response => $response );
}


sub get_ua {
    state $ua;

    $ua //= LWP::UserAgent->new;
    return $ua;
}

sub get_json {
    state $json;

	$json //= JSON->new->utf8;
    return $json;
}

1;
