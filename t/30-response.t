use strict;
use warnings;
use Test::More tests => 3;
use t::lib::FakeResponse;

BEGIN { use_ok('Regru::API::Response') }

my $serializer;

subtest 'Generic behaviour' => sub {
    plan tests => 5;

    my @attributes = qw(
        error_code
        error_text
        error_params
        is_success
        is_service_fail
        answer
        response
    );

    my @methods = qw(
        get
        _trigger_response
    );

    my $resp = new_ok 'Regru::API::Response';

    # cache serializer
    $serializer ||= $resp->serializer;

    can_ok $resp, @attributes;
    can_ok $resp, @methods;

    ok $resp->does('Regru::API::Role::Serializer'),     'Instance does the Serializer role';

    # applied by roles
    can_ok $resp, qw(serializer);
};

subtest 'Expected response case (success)' => sub {
    plan tests => 6;

    ok $serializer, 'Serializer available';

    my $sample = {
        answer => {
            user_id => 0,
            login => 'test',
        },
        result => 'success',
    };

    my $fake = t::lib::FakeResponse->compose(200, $serializer->encode($sample));

    my $resp = new_ok 'Regru::API::Response' =>[( response => $fake )];

    ok          $resp->is_success,                              'Response okay';
    is_deeply   $resp->answer,          $sample->{answer},      'Got expected answer';
    is          $resp->get('login'),    'test',                 'Field login as expected';
    cmp_ok      $resp->get('user_id'),  '==',   0,              'Field user_id as expected';
};

1;
