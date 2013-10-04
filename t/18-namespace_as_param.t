use strict;
use warnings;
use Test::More tests => 1;
use t::lib::NamespaceClient;
use t::lib::Connection;

my $api_avail;

subtest 'Grab namespace from parameters' => sub {
    my $client = t::lib::NamespaceClient->root;
    my $resp;

    $api_avail ||= t::lib::Connection->check($client->endpoint);

    unless ($api_avail) {
        diag 'Some tests were skipped. No connection to API endpoint.';
        plan skip_all => '.';
    }
    else {
        plan tests => 8;
    }

    # nop() API call shortcut
    my $nop = sub { $client->api_request('nop', @_) };

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
