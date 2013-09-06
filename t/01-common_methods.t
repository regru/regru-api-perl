use Test::More;


use_ok('Regru::API');
my $client = Regru::API->new(username => 'test', password => 'test');

# Функции общего назначения
my $regru_response = $client->nop;

ok($regru_response->is_success);
ok($regru_response->get('user_id'));
ok($regru_response->get('login'));


my $wrong_credentials_client = Regru::API->new(username => 'wrong login', password => 'wrong password');
$regru_response = $wrong_credentials_client->nop;

is($regru_response->error_text, 'Username/password Incorrect', "Error text check");
is($regru_response->error_code, 'PASSWORD_AUTH_FAILED', "Error code check");


done_testing();
