use strict;
use warnings;
use Test::More tests => 3;
use t::lib::NamespaceClient;
use t::lib::Connection;

my $api_avail;

subtest 'Generic behaviour' => sub {
    plan tests => 2;

    my @methods = qw(
        nop
        get_prices
        get_servtype_details
        create
        delete
        get_info
        get_list
        get_folders
        get_details
        service_get_details
        get_dedicated_server_list
        update
        renew
        get_bills
        set_autorenew_flag
        suspend
        resume
        get_depreciated_period
        upgrade partcontrol_grant
        partcontrol_revoke
        resend_mail
    );

    my $client = t::lib::NamespaceClient->service;

    isa_ok $client, 'Regru::API::Service';
    can_ok $client, @methods;
};

subtest 'Namespace methods (nop)' => sub {
    my $client = t::lib::NamespaceClient->service;
    my $resp;

    $api_avail ||= t::lib::Connection->check($client->endpoint);

    unless ($api_avail) {
        diag 'Some tests were skipped. No connection to API endpoint.';
        plan skip_all => '.';
    }
    else {
        plan tests => 1;
    }

    # /service/nop
    $resp = $client->nop(dname => 'test.ru');
    ok $resp->is_success,                                   'nop() success';
};

subtest 'Namespace methods (overall)' => sub {
    unless ($ENV{REGRU_API_OVERALL_TESTING}) {
        diag 'Some tests were skipped. Set the REGRU_API_OVERALL_TESTING to execute them.';
        plan skip_all => '.';
    }

    my $client = t::lib::NamespaceClient->service;
    my $resp;

    $api_avail ||= t::lib::Connection->check($client->endpoint);

    unless ($api_avail) {
        diag 'Some tests were skipped. No connection to API endpoint.';
        plan skip_all => '.';
    }
    else {
        plan tests => 19;
    }

    # /service/get_prices
    $resp = $client->get_prices;
    ok $resp->is_success,                                   'get_prices() success';

    # /service/get_servtype_details
    $resp = $client->get_servtype_details(servtype => 'srv_hosting_ispmgr');
    ok $resp->is_success,                                   'get_servtype_details() success';

    # /service/create
    $resp = $client->create(
        dname    => 'test.ru',
        servtype => 'srv_hosting_ispmgr',
        period   => 1,
        plan     => 'Host-2-1209',
    );
    ok $resp->is_success,                                   'create() success';

    # /service/delete
    $resp = $client->delete(
        dname    => 'test.ru',
        servtype => 'srv_hosting_ispmgr',
    );
    ok $resp->is_success,                                   'delete() success';

    # /service/{get_info,get_list,get_folders,get_details,service_get_details,get_bills}
    foreach my $method (qw/get_info get_list get_folders get_details service_get_details get_bills/) {
        $resp = $client->$method(dname => 'test.ru');
        ok $resp->is_success, "${method}() success";
    }

    # /service/update
    $resp = $client->update(
        dname      => 'test.ru',
        servtype   => 'srv_webfwd',
        fwd_action => 'addfwd',
        fwdfrom    => '\&',
        fwdto      => 'http://reg.ru',
        fwd_type   => 'redirect',
    );
    ok $resp->is_success,                                   'update() success';

    # /service/{renew,suspend,resume,get_depreciated_period}
    foreach my $method (qw/renew suspend resume get_depreciated_period/) {
        $resp = $client->$method(service_id => '12345', period => 2);
        ok $resp->is_success, "${method}() success";
    }

    # /service/set_autorenew_flag
    $resp = $client->set_autorenew_flag(flag_value => 1, service_id => 12345);
    ok $resp->is_success,                                   'set_autorenew_flag() success';

    # /service/partcontrol_grant
    $resp = $client->partcontrol_grant(
        newlogin   => 'test',
        service_id => 1,
    );
    ok $resp->is_success,                                   'partcontrol_grant() success';

    # /service/partcontrol_revoke
    $resp = $client->partcontrol_revoke(
        service_id => 1,
    );
    ok $resp->is_success,                                   'partcontrol_revoke() success';

    # /service/resend_mail
    $resp = $client->resend_mail(
        dname       => 'test.ru',
        servtype    => 'srv_hosting_ispmgr',
        service_id  => 1,
    );
    ok $resp->is_success,                                   'resend_mail() success';
};

1;
