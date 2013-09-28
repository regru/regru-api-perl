package Regru::API::Role::Client;

# ABSTRACT: REG.API v2 "client" role

use strict;
use warnings;
use Moo::Role;
use Regru::API::Response;
use namespace::autoclean;

# VERSION
# AUTHORITY

with qw(
    Regru::API::Role::Namespace
    Regru::API::Role::Serializer
    Regru::API::Role::UserAgent
    Regru::API::Role::Loggable
);

has username    => ( is => 'ro', required => 1 );
has password    => ( is => 'ro', required => 1 );
has io_encoding => ( is => 'ro' );
has lang        => ( is => 'ro' );
has debug       => ( is => 'ro' );

has namespace   => (
    is      => 'ro',
    default => sub { '' },
);

has endpoint => (
    is      => 'ro',
    default => sub { $ENV{REGRU_API_ENDPOINT} || 'https://api.reg.ru/api/regru2' },
);

sub namespace_methods {
    my $class = shift;

    my $meta = $class->meta;

    foreach my $method ( @{ $class->available_methods } ) {
        $method = lc $method;
        $method =~ s/\s/_/g;

        my $handler = sub {
            my ($self, @args) = @_;
            $self->api_request($method => @args);
        };

        $meta->add_method($method => $handler);
    }
}

sub api_request {
    my ($self, $method, %params) = @_;

    my $url = join '' => $self->endpoint,
                         $self->to_namespace(delete $params{namespace}), # compose namespace part
                        ($method ? '/' . $method : '');

    my %post_params = (
        username      => $self->username,
        password      => $self->password,
        output_format => 'json',
        input_format  => 'json'
    );

    $post_params{lang}          = $self->lang           if defined $self->lang;
    $post_params{io_encoding}   = $self->io_encoding    if defined $self->io_encoding;

    $self->debug_warn('API request:', $url, "\n", 'with params:', \%params) if $self->debug;

    my $json = $self->serializer->encode( \%params );

    my $response = $self->useragent->post(
        $url,
        [ %post_params, input_data => $json ]
    );

    return Regru::API::Response->new( response => $response );
}

sub to_namespace {
    my ($self, $namespace) = @_;

    $namespace = $namespace || $self->namespace || undef;

    return $namespace ? '/' . $namespace : '';
}

1; # End of Regru::API::Role::Client

__END__

=pod

=head1 SYNOPSIS

    # in some namespace package
    package Regru::API::Dummy;

    use strict;
    use warnings;
    use Moo;

    with 'Regru::API::Role::Client';

    has '+namespace' => (
        default => sub { 'dummy' },
    );

    sub available_methods {[qw(foo bar baz)]}

    __PACKAGE__->namespace_methods;
    __PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

Any class or role that consumes this role will able to execute requests to REG.API v2.

=attr username

Account name of the user to access to website L<https://www.reg.com>. Required.

=attr password

Account password of the user to access to website L<https://www.reg.com> or an alternative password for API
defined at L<Reseller settings|https://www.reg.com/reseller/details> page. Required.

=attr io_encoding

Defines encoding that will be used for data exchange between the Service and the Client. At the moment REG.API v2
supports the following encodings: I<utf8>, I<cp1251>, I<koi8-r>, I<koi8-u>, I<cp866>. Optional. Default value is B<utf8>.

=attr lang

Defines the language which will be used in error messages. At the moment REG.API v2 supports the following languages:
English (I<en>), Russian (I<ru>) and Thai (I<th>). Optional. Default value is B<en>.

=attr debug

Enables the debug mode. Prints some garbage.

=attr namespace

Used internally.

=attr endpoint

REG.API v2 endpoint url. There's no needs to change it. Although it might be overridden by setting environment variable:

    export REGRU_API_ENDPOINT=https://api.example.com

Default value is

    https://api.reg.ru/api/regru2

=method namespace_methods

Dynamically creates methods-shortcuts in in namespaces (categories) for requests to appropriate REG.API v2 functions.

=method api_request

Performs an API request to REG.API service. Returns a L<Regru::API::Response> object.

=method to_namespace

Used internally.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Namespace>

L<Regru::API::Role::Serializer>

L<Regru::API::Role::UserAgent>

L<Regru::API::Role::Loggable>

L<Regru::API::Response>

=cut
