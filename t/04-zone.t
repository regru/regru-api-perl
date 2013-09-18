use Test::More;
use Regru::API;
use Net::Ping;

my $client
    = Regru::API->new( username => 'test', password => 'test', lang => 'ru' );

plan skip_all => "Internet connection problem"
    unless Net::Ping->new->ping('reg.ru');

ok( $client->zone->nop( dname => 'test.ru' )->is_success,
    'zone/nop API call test' );

SKIP: {

    skip "For calling all API functions set ALL_TEST env var to 1", 14
        unless $ENV{ALL_TESTS};

    ok( $client->zone->add_alias(
            domains   => [ { dname => 'test.ru' } ],
            subdomain => '@',
            ipaddr    => '111.111.111.111'
            )->is_success,
        'zone/add_alias API call test'
    );
    ok( $client->zone->add_aaaa(
            domains   => [ { dname => 'test.ru' } ],
            subdomain => '@',
            ipaddr    => '111.111.111.111'
            )->is_success,
        'zone/add_aaaa API call test'
    );
    ok( $client->zone->add_cname(
            domains        => [ { dname => 'test.ru' } ],
            subdomain      => '@',
            canonical_name => 'mx10.test.ru'
            )->is_success,
        'zone/add_cname API call test'
    );
    ok( $client->zone->add_mx(
            domains     => [ { dname => 'test.ru' } ],
            subdomain   => '@',
            mail_server => 'mail.test.ru'
            )->is_success,
        'zone/add_mx API call test'
    );
    ok( $client->zone->add_ns(
            domains       => [ { dname => 'test.ru' } ],
            subdomain     => '@',
            dns_server    => 'dns.test.ru',
            record_number => 10,
            )->is_success,
        'zone/add_ns API call test'
    );

    ok( $client->zone->add_srv(
            domains => [ { dname => 'test.ru' } ],
            service => 'sip',
            target  => 'testtarget.ru',
            port    => 5060,
            )->is_success,
        'zone/add_ns API call test'
    );

    ok( $client->zone->get_resource_records(
            domains => [ { dname => 'test.ru' } ],
            )->is_success,
        'zone/get_resourse_records API call test'
    );

    my $action_list = [
        {   action    => 'add_alias',
            subdomain => 'www',
            ipaddr    => '11.22.33.44'
        },
        {   action         => 'add_cname',
            subdomain      => '@',
            canonical_name => 'www.test.ru'
        }
    ];
    ok( $client->zone->update_records(
            action_list => $action_list,
            dname       => 'test.ru'
            )->is_success,
        'zone/update_records API call test'
    );

    ok( $client->zone->update_soa(
            ttl         => '1d',
            miminum_ttl => '4h',
            dname       => 'test.ru'
            )->is_success,
        'zone/update_soa API call test'
    );

    ok( $client->zone->tune_forwarding( dname => 'test.ru' )->is_success,
        'zone/tune_forwarding API call test' );

    ok( $client->zone->tune_parking( dname => 'test.ru' )->is_success,
        'zone/tune_parking API call test' );

    ok( $client->zone->clear_parking( dname => 'test.ru' )->is_success,
        'zone/clear_parking API call test' );

    ok( $client->zone->remove_record(
            dname       => 'test.ru',
            subdomain   => '@',
            content     => '111.111.111.111',
            record_type => 'A'
            )->is_success,
        'zone/remove_record API call test'
    );
    ok( $client->zone->clear( dname => 'test.ru', )->is_success,
        'zone/clear API call test' );

}

done_testing();
