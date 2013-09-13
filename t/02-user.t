use Test::More;
use Regru::API;
use Net::Ping;


$client = Regru::API->new(
    username    => 'test',
    password    => 'test',
    lang        => 'th',
    io_encoding => 'cp1251',
);
my $unauth_client = Regru::API->new;


plan skip_all => "Internet connection problem"
        unless Net::Ping->new->ping('reg.ru');

ok( $client->user->nop->is_success, 'user/nop API call test' );

SKIP: {
    skip "For calling all API functions set ALL_TEST env var to 1", 9
        unless $ENV{ALL_TESTS};


    my $response = $client->user->create(
        user_login        => 'othertest',
        user_password     => 'xxxx',
        user_email        => 'test@test.ru',
        user_country_code => 'ru'
    );
    is( $response->error_code, 'INVALID_CONTACTS',
        "Check error code for user/create" );

    $response = $client->user->get_statistics;
    ok( $response->is_success, "user/get_statistics call test" );
    is( $response->get('balance_total'), 100, 'Test user balance test' );

    is( $client->user->get_balance->get('prepay'),
        1000, 'user/get_balance API call test' );
    is( $client->user->get_balance( currency => 'UAH' )->get('currency'),
        'UAH', 'user/balance currency API call test' );

    my $refill_balance_response = $client->user->refill_balance(
        pay_type => 'WM',
        wmid     => 123456789012,
        currency => 'RUR',
        amount   => 100
    );
    ok( $refill_balance_response->is_success,
        'user/refill_balance API call test'
    );
    is( $refill_balance_response->get('payment'),
        100, 'user/refill_balance payment amount test' );

    ok( not $unauth_client->user->refill_balance->is_success );
    is( $unauth_client->user->refill_balance->error_code,
        'NO_USERNAME', 'Error code for unauthenticated user check' );

}

done_testing();
