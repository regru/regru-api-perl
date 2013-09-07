use Test::More;

use Regru::API;
use Data::Dumper;
$client = Regru::API->new(username => 'test', password => 'test', lang => 'th', io_encoding => 'cp1251');

ok($client->user->nop->is_success);

my $response = $client->user->create(user_login => 'othertest', user_password => 'xxxx');
is($response->error_code, 'INVALID_CONTACTS', "Check error code for user/create");

done_testing();