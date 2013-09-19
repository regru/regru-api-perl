package Regru::API::Role::Client;

# ABSTRACT: Reg.ru API "client" role

use strict;
use warnings;
use Moo::Role;
use Carp ();
use Regru::API::Response;
use Data::Dumper;
use namespace::autoclean;

with qw(
    Regru::API::Role::Namespace
    Regru::API::Role::Serializer
    Regru::API::Role::UserAgent
);

has username    => ( is => 'ro' );
has password    => ( is => 'ro' );
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
            $self->_api_call($method => @args);
        };

        $meta->add_method($method => $handler);
    }
}

sub _debug_log {
    my ($self, $message) = @_;

    Carp::carp $message if $self->debug;
}

sub _api_call {
    my ($self, $method, %params) = @_;

    my $url = join '' => $self->endpoint,
                        ($self->namespace ? '/' . $self->namespace : ''),
                        ($method ? '/' . $method : '');

    my %post_params = (
        username      => $self->username,
        password      => $self->password,
        output_format => 'json',
        input_format  => 'json'
    );

    $post_params{lang}          = $self->lang           if defined $self->lang;
    $post_params{io_encoding}   = $self->io_encoding    if defined $self->io_encoding;

    $self->_debug_log('API request: ' . $url);
    $self->_debug_log('Params: ' . Dumper(\%params));

    my $json = $self->serializer->encode( \%params );

    my $response = $self->useragent->post(
        $url,
        [ %post_params, input_data => $json ]
    );

    return Regru::API::Response->new( response => $response );
}

1; # End of Regru::API::Role::Client

__END__

=pod

=head1 NAME

Regru::API::Role::Client - Reg.ru API "client" role

=head1 SYNOPSYS
    # in some namespace package
    package Regru::API::Dummy;

    use strict;
    use warnings;
    use Moo;

    with 'Regru::API::Role::Client';

    has '+namespace' => (
        is      => 'ro',
        default => sub { 'dummy' },
    );

    sub available_methods {[qw(foo bar baz)]}

    __PACKAGE__->namespace_methods;
    __PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

=head2 New namespace handler creation

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
