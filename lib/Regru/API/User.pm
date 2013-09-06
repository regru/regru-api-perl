package Regru::API::User;
use Modern::Perl;
use parent 'Regru::API::Category';

my @methods = qw/nop create get_statistics get_balance refill_balance/;
my $namespace = 'user';


=head1 NAME

    Regru::API::User - package for methods related to user category.

=head1 METHODS


=head2 nop

Does nothing. 

    my $response = $client->user->nop;


=head2 create


=head2 get_statistics

Returns statistics for current user.

Options:

=over

=item date_from

    start date for period, unnecessary

=item date_to

    end date for period, unnecessary

=back

    my $response = $client->user->get_statistics;
    say $response->get("costs_for_period") if $response->is_success;


=head2 get_balance

Returns balance for current user.

    my $currency = 'UAH';
    my $response = $client->user->get_balance(currency => $currency);
    say "Balance: " . $response->get("prepay") . " ". $currency if $response->is_success;

Options: 

=over
    
=item currency

    currency for output sum, RUR by default.

=back

=cut

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_, methods => \@methods, namespace => $namespace );
    return $self;
}



1;
