use strict;
use warnings;
use Test::More tests => 1;
use Regru::API;

subtest 'Grab namespace from parameters' => sub {
    plan tests => 8;

    my $client = Regru::API->new(username => 'test', password => 'test');

    # nop() API call shortcut
    my $nop = sub { $client->api_request('nop', @_) };

    my $resp;

    # /nop (default)
    $resp = $nop->();
    ok $resp->is_success,                                   'nop() default success';

    # /nop (with namespace)
    $resp = $nop->(namespace => '');
    ok $resp->is_success,                                   'nop() with namespace success';

    # /user/nop
    $resp = $nop->(namespace => 'user');
    ok $resp->is_success,                                   'user/nop() success';

    # /domain/nop
    $resp = $nop->(namespace => 'domain');
    ok $resp->is_success,                                   'domain/nop() success';

    # /zone/nop
    $resp = $nop->(namespace => 'zone', dname => 'test.ru');
    ok $resp->is_success,                                   'zone/nop() success';

    # /bill/nop
    $resp = $nop->(namespace => 'bill', bill_id => 1234);
    ok $resp->is_success,                                   'bill/nop() success';

    # /folder/nop
    $resp = $nop->(namespace => 'folder', folder_name => 'qqq');
    ok $resp->is_success,                                   'folder/nop() success';

    # /service/nop
    $resp = $nop->(namespace => 'service', dname => 'test.ru');
    ok $resp->is_success,                                   'service/nop() success';
};

1;
