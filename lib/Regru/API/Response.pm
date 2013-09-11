package Regru::API::Response;
use Modern::Perl;
use Data::Dumper;

use Moo;

my @getters = qw/error_text error_code is_success error_params is_service_fail answer response/;
has [@getters] => ( is => 'ro');


sub BUILD {
    my $self = shift;

    my $response = $self->response;
    if ( $response->is_success ) {
        my $raw     = $response->decoded_content;
        my $json    = Regru::API::NamespaceHandler::get_json();
        my $decoded = $json->decode($raw);
        my $success = $decoded->{result} eq 'success';
        $self->{ is_success } = $success;
        if ($success) {
            $self->{ answer } = $decoded->{answer};
        }
        else {
            $self->{ $_ } = $decoded->{ $_ } for qw/error_code error_text error_params/;
        }
    }
    else {
        $self->{ success } = 0;
        $self->{ is_service_fail } = 1;
    }
}


=head1 NAME 

Regru::API::Response - object wrapper for service answer.

=cut

=head1 METHODS

=head2 is_success

Returns 1 if API call is succeeded, 0 otherwise.

=head2 error_text

Returns error text if an error occured, default language for error messages is english.
Language can be set in Regru::API constructor with C<lang> option.

=head2 error_code

Returns error code if an error occured. Full list error codes list is available at L<https://www.reg.ru/support/help/API-version2#std_error_codes>.

=head2 error_params

Params for error text. 
    
    my $error_params = $response->error_params;
    my $detail = $error_params->{ error_detail };

=head2 is_service_fail

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

=head2 response

Returns L<HTTP::Response> object with API response.
    
    if ($api_response->is_service_fail) {
        print "HTTP code: ".$api_response->response->code;
    }

=cut

=head2 get

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

=cut

sub get {
    my $self      = shift;
    my $attr_name = shift;

    my $answer = $self->answer;
    return $answer->{$attr_name};
}


1;
