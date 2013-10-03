package Regru::API::Role::Loggable;

# ABSTRACT: something that produces a debug messages

use strict;
use warnings;
use Moo::Role;
use namespace::autoclean;
use Data::Dumper;
use Carp;

# VERSION
# AUTHORITY

sub debug_warn {
    my ($self, @garbage) = @_;

    local $Data::Dumper::Terse      = 1;
    local $Data::Dumper::Indent     = 0;
    local $Data::Dumper::Useqq      = 1;
    local $Data::Dumper::Pair       = ': ';
    local $Data::Dumper::Sortkeys   = 1;

    my $msg = join ' ' => map { (ref $_ ? Dumper($_) : $_) } @garbage;

    carp $msg;
}

1;  # End of Regru::API::Role::Loggable

__END__

=pod

=head1 SYNOPSIS

    package Regru::API::Dummy;
    ...
    with 'Regru::API::Role::Loggable';

    # inside some method
    sub foo {
        my ($self) = @_;
        ...
        $ref = { -answer => 42 };
        $sclr = 'quux';

        $self->debug_warn('Foo:', 'bar', 'baz', $ref, $sclr, qw(knock,  knock));
        # will warn
        # Foo: bar baz {"-answer": 42} quux knock, knock at ...
    }

=head1 DESCRIPTION

Role provides the method which will be useful for debugging requests and responses.

=method debug_warn

Produces a warning message for a given list of agruments. All passed references (ArrayRef, HashRef or blessed)
will be flatten to the scalars. Output message will be done by joining scalars with C<space> character as separator.

=head1 SEE ALSO

L<Regru::API>

L<Regru::API::Role::Client>

=cut
