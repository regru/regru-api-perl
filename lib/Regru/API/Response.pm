package Regru::API::Response;

# ABSTRACT: REG.API v2 response wrapper

use strict;
use warnings;
use Moo;
use Try::Tiny;
use Carp ();
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Serializer';

has error_code      => ( is => 'rw' );
has error_text      => ( is => 'rw' );
has error_params    => ( is => 'rw' );
has is_success      => ( is => 'rw' );
has is_service_fail => ( is => 'rw' ); # XXX: should be implemented

has answer => (
    is      => 'rw',
    default => sub { +{} }
);

has response => (
    is      => 'rw',
    trigger => 1,
);

sub _trigger_response {
    my ($self, $response) = @_;

    if ($response) {
        try {
            my $decoded = $self->serializer->decode($response->decoded_content);
            $self->is_success($decoded->{result} && $decoded->{ result } eq 'success');

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
            Carp::carp 'Unable to decode response: ' . $_;
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

=head1 DESCRIPTION

REG.API response... (to be described)

=attr is_success

Returns 1 if API call is succeeded, 0 otherwise.

=attr error_text

Returns error text if an error occured, default language for error messages is english.
Language can be set in L<Regru::API> constructor with C<lang> option.

=attr error_code

Returns error code if an error occured. Full list error codes list is available at L<https://www.reg.com/support/help/API-version2#std_error_codes>.

=attr error_params

Params for error text.

    my $error_params = $response->error_params;
    my $detail = $error_params->{ error_detail };

=attr is_service_fail

Returns true if API service answer code isn't 200.

    my $response = $client->bill->nop(bill_id => 123213);
    if ($response->is_success) {
        print "It works";
    }
    elsif ($response->is_service_fail) {
        print "Reg.ru API is gone :("
    }
    else {
        die "Error code: ". $response->error_code;
    }

=attr response

Returns L<HTTP::Response> object with API response.

    if ($api_response->is_service_fail) {
        print "HTTP code: ".$api_response->response->code;
    }

=method get

    my $value = $response->get($param_name);

Returns param value from API response, if API call is succeeded.

    my $response = $client->user->get_statistics;
    say "Total balance: " . $response->get("balance_total");

    L<https://www.reg.ru/support/help/API-version2#user_get_statistics>

    ...

    my $bills_answer = $client->bill->nop(bill_id => 1235);
    if ($bills_answer->is_success) {
        say $bills_answer->get('bills')->[0]->{ bill_id };
    }

    L<https://www.reg.ru/support/help/API-version2#bill_nop>

=head1 SEE ALSO

L<Regru::API::Role::Serializer>

=cut
