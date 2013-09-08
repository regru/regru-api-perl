use Test::More;
use Regru::API;
my ( $username, $password ) = ( 'test', 'test' );
my $client = Regru::API->new( username => $username, password => $password );

ok($client->domain->nop->is_success, 'domain/nop API call test');
my $prices = $client->domain->get_prices->get('prices');
isa_ok($prices, 'HASH', 'Prices type test');
ok($prices->{ ru })->{ reg_price }, 'domain/get_prices ru/reg_price exists test');


my $suggestions = $client->domain->get_suggest(word => 'дом', tld => 'рф');
ok($suggestions->is_success, 'domain/get_suggest API call test');
ok($suggestions->get('suggestions'));

my $premium = $client->domain->get_premium(tld => 'рф', limit => 5);
ok($premium->is_success, 'domain/get_premium API call test');



done_testing();
