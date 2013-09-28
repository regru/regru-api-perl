use strict;
use warnings;
use Test::More tests => 2;

{
    # role consumer
    package Foo::Bar;

    use strict;
    use Moo;

    with 'Regru::API::Role::Client';

    has '+namespace' => (
        default => sub { 'dummy' },
    );

    sub available_methods {[qw(baz quux)]}

    __PACKAGE__->namespace_methods;
    __PACKAGE__->meta->make_immutable;

    1;
}

subtest 'Client role' => sub {
    plan tests => 10;

    my $foo = new_ok 'Foo::Bar' => [(username => 'foo', password => 'bar')];

    isa_ok $foo, 'Foo::Bar';

    # api methods
    can_ok $foo, qw(baz quux);

    # roles
    ok $foo->does('Regru::API::Role::UserAgent'),       'Instance does the UserAgent role';
    ok $foo->does('Regru::API::Role::Namespace'),       'Instance does the Namespace role';
    ok $foo->does('Regru::API::Role::Serializer'),      'Instance does the Serializer role';
    ok $foo->does('Regru::API::Role::Loggable'),        'Instance does the Loggable role';

    # applied by roles
    can_ok $foo, qw(useragent serializer debug_warn);

    # attributes
    can_ok $foo, qw(username password io_encoding lang debug namespace endpoint);

    # native methods
    can_ok $foo, qw(namespace_methods api_request to_namespace);
};

subtest 'Native methods' => sub {
    plan tests => 8;

    # save endpoint
    my $endpoint = $ENV{REGRU_API_ENDPOINT} || undef;

    $ENV{REGRU_API_ENDPOINT} = 'http://api.example.com/v2';

    my $foo = new_ok 'Foo::Bar' => [(username => 'foo', password => 'bar')];

    is          $foo->namespace,            'dummy',                    'Attribute namespace overwritten okay';
    is_deeply   $foo->available_methods,    [qw(baz quux)],             'Correct list of API methods';
    is          $foo->endpoint,             $ENV{REGRU_API_ENDPOINT},   'API endpoint spoofed okay';


    is          $foo->to_namespace(),       '/dummy',                   'Missed namespace okay';
    is          $foo->to_namespace(undef),  '/dummy',                   'Undefined namespace passed okay';
    is          $foo->to_namespace(''),     '/dummy',                   'Empty namespace passed okay';
    is          $foo->to_namespace('foo'),  '/foo',                     'Namespace overwritten okay';

    # restore endpoint
    $ENV{REGRU_API_ENDPOINT} = $endpoint if $endpoint;
};

1;
