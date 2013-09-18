use strict;
use warnings;
use Test::More tests => 1;

# XXX: need testing role requirements for consumer
# XXX: at the moment - presence of available_methods()

{
    # role consumer
    package Foo::Bar;

    use strict;
    use Moo;

    with 'Regru::API::Role::Namespace';

    sub available_methods { [qw(foo bar)] }

    1;
}

subtest 'Namespace role' => sub {
    plan tests => 4;

    my $foo = new_ok 'Foo::Bar';

    isa_ok $foo, 'Foo::Bar';
    can_ok $foo, 'available_methods';

    ok $foo->does('Regru::API::Role::Namespace'),       'Instance does the Namespace role';
};

1;
