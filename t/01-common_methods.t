use Test::More;


use_ok('Regru::API');
my $client = Regru::API->new(username => 'test', password => 'test');

isa_ok($client, 'Regru::API::Category');


# Функции общего назначения
my $regru_response = $client->nop;

ok($regru_response->is_success, 'Success answer test');
is($regru_response->get('user_id'), 0, 'Test user id check');
ok($regru_response->get('login'));

$regru_response = $client->reseller_nop;
ok($regru_response->is_success, 'Success reseller_nop call');
is($regru_response->get("login"), 'test', 'Test login got');


$regru_response = $client->get_user_id;
ok($regru_response->is_success, 'get_user_id call succeeded');
is($regru_response->get('user_id'), 0, 'Test user_id got');


$regru_response = $client->get_service_id;
ok($regru_response->is_success);
is($regru_response->get('service_id'), '12345', 'Test service_id got');

my $wrong_credentials_client = Regru::API->new(username => 'wrong login', password => 'wrong password');
$regru_response = $wrong_credentials_client->nop;

is($regru_response->error_text, 'Username/password Incorrect', "Error text check");
is($regru_response->error_code, 'PASSWORD_AUTH_FAILED', "Error code check");


done_testing();
