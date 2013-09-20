package Regru::API::Bill;

# ABSTRACT: REG.API v2 "bill" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    is      => 'ro',
    default => sub { 'bill' },
);

sub available_methods {[qw(
    nop
    get_not_payed
    get_for_period
    change_pay_type
    delete
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::Bill

__END__

=pod

=head1 DESCRIPTION

REG.API bill category... (to be described)

=method nop

...

=method get_not_payed

...

=method get_for_period

...

=method change_pay_type

...

=method delete

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
