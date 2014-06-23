package Regru::API::Response;

# ABSTRACT: REG.API v2 response wrapper

use strict;
use warnings;
use Moo;
use Try::Tiny;
use Carp;
use namespace::autoclean;

# VERSION
# AUTHORITY

with qw(
    Regru::API::Role::Serializer
    Regru::API::Role::Loggable
);

has error_code      => ( is => 'rw' );
has error_text      => ( is => 'rw' );
has error_params    => ( is => 'rw' );
has is_success      => ( is => 'rw' );
has is_service_fail => ( is => 'rw' );

has answer => (
    is      => 'rw',
    default => sub { +{} }
);

has response => (
    is      => 'rw',
    trigger => 1,
);

has debug => (
    is      => 'rw',
    default => sub { 0 }
);

sub _trigger_response {
    my ($self, $response) = @_;

    if ($response) {
        try {
            die 'Invalid response' unless ref $response eq 'HTTP::Response';

            $self->debug_warn('REG.API response code', $response->code) if $self->debug;

            $self->is_service_fail($response->code == 200 ? 0 : 1);

            if ($self->is_service_fail) {
                # Stop processing response
                $self->is_success(0);
                die 'Service failed: ' . ($response->decoded_content || $response->content);
            }

            my $decoded = $self->serializer->decode($response->decoded_content || $response->content);
            $self->is_success($decoded->{result} && $decoded->{result} eq 'success');

            $self->debug_warn('REG.API request', ($self->is_success ? 'success' : 'fail')) if $self->debug;
            if ($self->is_success) {
                $self->answer($decoded->{answer});
            }
            else {
                foreach my $attr (qw/error_code error_text error_params/) {
                    $self->$attr($decoded->{$attr});
                }
            }
        }
        catch {
            carp 'Error: ' . $_;
            $self->error_code('API_FAIL');
            $self->error_text('API response error');
        };
    }
}

sub get {
    my ($self, $attr) = @_;

    return $self->answer->{$attr};
}

1; # End of Regru::API::Response

__END__

=pod

=head1 SYNOPSIS

    my $resp = Regru::API::Response->new(
        response => $response,
    );

=attr is_service_fail

Flag to show whether or not the most last answer from the API service has not been finished with code I<HTTP 200>.

    $resp = $client->bill->nop(bill_id => 123213);

    if ($resp->is_success) {
        print "It works!";
    }
    elsif ($resp->is_service_fail) {
        print "Reg.ru API is gone :(";
    }
    else {
        print "Error code: ". $resp->error_code;
    }

=attr is_success

Flag to show whether or not the most last API request has been successful.

See example for L</is_service_fail>.

=attr response

Contains a L<HTTP::Response> object for the most last API request.

    if ($resp->is_service_fail) {
        print "HTTP code: " . $resp->response->code;
    }

=attr answer

Contains decoded answer for the most last successful API request.

    if ($resp->is_success) {
        print Dumper($resp->answer);
    }

This is useful for debugging;

=attr error_code

Contains error code for the most last API request if it has not been successful.

Full list error codes list is available at
L<REG.API Common error codes|https://www.reg.com/support/help/api2#common_errors>.

=attr error_text

Contains common error text for the most last API request if it has not been successful.

Default language is B<enlish>. Language can be changed by passing option C<lang> to the
L<Regru::API> constructor.

=attr error_params

Contains additional parameters included into the common error text.

    $error_params = $resp->error_params;
    print "Details: " . $error_params->{error_detail};

=attr debug

A few messages will be printed to STDERR. Default value is B<0> (suppressed debug activity).

=method new

Creates a response object from REG.API response. Available options:

=over

=item B<response>

Required. This should be a result of HTTP request to REG.API. In general, is a L<HTTP::Response> object returned by
L<LWP::UserAgent>.

=item B<debug>

Not required. Print some debugging messages to STDERR. Default value is B<0>. Because of this contructor invoked from
L<Regru::API::Role::Client> mainly so this option sets to the value which passed to L<Regru::API> constructor.

=back

=method get

Gets a value from stored in answer.

    $resp = $client->user->get_statistics;
    print "Account balance: " . $resp->get("balance_total");

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

L<Regru::API::Role::Serializer>

L<Regru::API::Role::Loggable>

L<HTTP::Response>

L<LWP::UserAgent>

L<REG.API Common error codes|https://www.reg.com/support/help/api2#common_errors>

=cut
