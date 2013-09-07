package Regru::API::Response;
use Modern::Perl;
use Data::Dumper;
# use Moose;

use Moo;


has [ 'error_text', 'error_code', 'is_success', 'error_params' ] => ( is => 'rw' );
has 'raw_content' => (is => 'ro', trigger => \&_parse_answer );
has 'answer' => ( is => 'rw', default => sub { return {}; });

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



=head2 get

    my $value = $response->get($param_name);

Returns param value from API response, if API call is succeeded.

    my $response = $client->user->get_statistics;
    say "Total balance: " . $response->get("balance_total");

=cut

sub get {
	my $self = shift;
	my $attr_name = shift;

	my $answer = $self->answer;
	return $answer->{ $attr_name };
}

sub _parse_answer {
	my $self = shift;
	my $raw_content = shift;

	require JSON;
	my $decoded = JSON->new->decode($raw_content);
	my $success = $decoded->{ result } eq 'success';
	$self->is_success($success);
	if ($success) {
		my $answer = $decoded->{ answer };
		$self->answer($answer);
	}
	else {
		$self->error_code($decoded->{ error_code });
		$self->error_text($decoded->{ error_text });
		$self->error_params($decoded->{ error_params });
	}

}

1;
