use Test::More;
use Regru::API;
use Net::Ping;

my $client = Regru::API->new( username => 'test', password => 'test' );

plan skip_all => "Internet connection problem"
    unless Net::Ping->new->ping('reg.ru');

ok( $client->service->nop( dname => 'test.ru' )->is_success,
    'service/nop API call test' );

SKIP: {

    skip "For calling all API functions set ALL_TEST env var to 1", 14
        unless $ENV{ALL_TESTS};

    ok( $client->service->get_prices->is_success,
        'service/get_prices API call test'
    );
    ok( $client->service->get_servtype_details(
            servtype => 'srv_hosting_ispmgr'
            )->is_success,
        'service/get_servtype_details API call test'
    );
    ok( $client->service->create(
            dname    => 'test.ru',
            servtype => 'srv_hosting_ispmgr',
            period   => 1,
            plan     => 'Host-2-1209'
            )->is_success,
        'service/create API call test'
    );
    ok( $client->service->delete(
            dname    => 'test.ru',
            servtype => 'srv_hosting_ispmgr',
            )->is_success,
        'service/delete API call test'
    );

    for my $method (
        qw/get_info get_list get_folders get_details
        service_get_details get_bills/
        )
    {
        ok( $client->service->$method( dname => 'test.ru', )->is_success,
            "service/$method API call test" );
    }

    ok( $client->service->update(
            dname      => 'test.ru',
            servtype   => 'srv_webfwd',
            fwd_action => 'addfwd',
            fwdfrom    => '\&',
            fwdto      => 'http://reg.ru',
            fwd_type   => 'redirect'
            )->is_success,
        'service/update API call test'
    );

    for my $method (
        qw/renew set_autorenew_flag suspend resume get_deprecated_period/)
    {
        ok( $client->service->$method( service_id => '12345', period => 2 ),
            "service/$method API call test" );
    }

    ok( $client->service->update(
            subtype  => 'Host-2-1209',
            period   => 2,
            servtype => 'srv_hosting_ispmgr',
            name     => 'qqq.ru'
        ),
        'service/update API call test'
    );

    ok( $client->service->partcontrol_grant(
            newlogin   => 'test',
            service_id => 1
        ),
        'service/partcontrol_grant API call test'
    );

    ok( $client->service->partcontrol_revoke( service_id => 1 ),
        'service/partcontrol_revoke API call test' );

    ok( $client->service->resend_mail(
            newlogin   => 'test',
            service_id => 1
        ),
        'service/resend_mail API call test'
    );
}

done_testing();
