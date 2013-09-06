package Regru::API::Response;
use Modern::Perl;

use Moose;

has 'success' => ( is => 'ro', isa => 'Bool' );
has [ 'error_text', 'error_code' ] => ( is => 'ro', isa => 'String' );
has 'error_params' => ( is => 'ro', isa => 'HashRef' );

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

=cut

sub new {
    # get HTTP::Response object, parse data and fill object fields
}

=head2 get

    my $value = $response->get($param_name);

Returns param value from API response, if API call is succeeded.

    my $response = $client->user->get_statistics;
    say "Total balance: " . $response->get("balance_total");

=cut

sub get {

}

1;
