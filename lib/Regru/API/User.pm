package Regru::API::User;

# ABSTRACT: REG.API v2 "user" category

use strict;
use warnings;
use Moo;
use namespace::autoclean;

# VERSION
# AUTHORITY

with 'Regru::API::Role::Client';

has '+namespace' => (
    default => sub { 'user' },
);

sub available_methods {[qw(
    nop
    create
    get_statistics
    get_balance
    refill_balance
)]}

__PACKAGE__->namespace_methods;
__PACKAGE__->meta->make_immutable;

1; # End of Regru::API::User

__END__

=pod

=head1 DESCRIPTION

REG.API user category... (to be described)

=apimethod nop

...

=apimethod create

...

=apimethod get_statistics

...

=apimethod get_balance

...

=apimethod refill_balance

...

=attr namespace

...

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
