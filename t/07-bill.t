use Test::More;
use Regru::API;
use Net::Ping;

my $client = Regru::API->new( username => 'test', password => 'test' );

plan skip_all => "Internet connection problem"
    unless Net::Ping->new->ping('reg.ru');

ok( $client->bill->nop( bill_id => 1234 )->is_success,
    'bill/nop API call test' );


SKIP: {

    skip "For calling all API functions set ALL_TEST env var to 1", 8
        unless $ENV{ALL_TESTS};

    ok( $client->bill->get_not_payed->is_success,
        'bills/get_not_payed API call test'
    );
    ok( $client->bill->get_for_period(
            limit      => 5,
            start_date => '1917-10-26',
            end_date   => '1917-10-07'
            )->is_success,
        'bills/get_for_period API call test'
    );

    ok( $client->bill->change_pay_type(
            bill_id  => 1234,
            pay_type => 'prepay',
            currency => 'RUR'
            )->is_success,
        'bill/change_pay_type API call test'
    );
    ok( $client->bill->delete( bill_id => 1234 )->is_success,
        'bill/delete API call test' );

}
done_testing();
