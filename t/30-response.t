use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok('Regru::API::Response') }

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

    can_ok $resp, @attributes;
    can_ok $resp, @methods;

    ok $resp->does('Regru::API::Role::Serializer'),      'Instance does the Serializer role';

    # applied by roles
    can_ok $resp, qw(serializer);
};

1;
