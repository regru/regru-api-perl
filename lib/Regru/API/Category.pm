package Regru::API::Category;
use Modern::Perl;
use Data::Dumper;

use Moose;

has 'methods' => (is => 'ro', isa => 'ArrayRef');
has 'namespace' => ( is => 'ro', isa => 'Str');


=head1 NAME

	Regru::API::Category - parent handler for all categories handlers.

=cut

sub AUTOLOAD {
	my $self = shift;
	# сделать зпрос к АПИ
}



1;