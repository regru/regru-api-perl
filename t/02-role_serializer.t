use strict;
use warnings;
use Test::More tests => 2;
use Test::Fatal;

{
    # role consumer
    package Foo::Bar;

    use strict;
    use Moo;

    with 'Regru::API::Role::Serializer';

    1;
}

subtest 'Serializer role' => sub {
    plan tests => 5;

    my $foo = new_ok 'Foo::Bar';

    isa_ok $foo, 'Foo::Bar';
    can_ok $foo, 'serializer';

    ok $foo->does('Regru::API::Role::Serializer'), 'Instance does the Serializer role';

    my $json = $foo->serializer;

    isa_ok $json, 'JSON';
};

subtest 'Bogus serializer' => sub {
    plan tests => 3;

    # wtf-serializer
    my $bogus = bless { -answer => 42 }, 'Bogus::Serializer';

    my $foo;

    my $new_failed = exception { $foo = Foo::Bar->new(serializer => $bogus) };
    like $new_failed, qr/is not a JSON instance/,        'catch exception thrown on create object';

    # use defaults
    $foo = new_ok 'Foo::Bar';

    my $set_failed = exception { $foo->serializer($bogus) };
    like $set_failed, qr/is not a JSON instance/,        'catch exception thrown on change attribute';
};

1;
