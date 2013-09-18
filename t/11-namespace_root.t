use strict;
use warnings;
use Test::More tests => 3;

subtest 'Generic behaviour' => sub {
    plan tests => 5;

    use_ok 'Regru::API';

    my @methods    = qw/nop reseller_nop get_user_id get_service_id/;
    my @namespaces = qw/user domain zone bill folder service/;

    my $client = new_ok 'Regru::API' => [( username => 'test', password => 'test' )];

    isa_ok $client, 'Regru::API';
    can_ok $client, @methods;
    can_ok $client, @namespaces;
};

subtest 'Namespace methods' => sub {
    plan tests => 9;

    my $client = Regru::API->new( username => 'test', password => 'test' );
    my $resp;

    # /nop
    $resp = $client->nop;
    ok $resp->is_success,                   'nop() success';
    is $resp->get('user_id'), 0,            'nop() got correct user_id';
    ok $resp->get('login'),                 'nop() got correct login';

    # /reseller_nop
    $resp = $client->reseller_nop;
    ok $resp->is_success,                   'reseller_nop() success';
    is $resp->get('login'), 'test',         'reseller_nop() got correct login';

    # /get_user_id
    $resp = $client->get_user_id;
    ok $resp->is_success,                   'get_user_id() success';
    is $resp->get('user_id'), 0,            'get_user_id() got correct user_id';

    # /get_service_id
    $resp = $client->get_service_id;
    ok $resp->is_success,                   'get_service_id() seccess';
    is $resp->get('service_id'), 12345,     'get_service_id() got correct service_id';
};

subtest 'Invalid credentials' => sub {
    plan tests => 2;

    my $client = Regru::API->new(
        username => 'wrong login',
        password => 'wrong password'
    );

    my $resp = $client->nop;

    is $resp->error_text, 'Username/password Incorrect',        'Got correct error description';
    is $resp->error_code, 'PASSWORD_AUTH_FAILED',               'Got correct error code';
};

1;
