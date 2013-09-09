use Test::More;
use Regru::API;
use utf8;

my ( $username, $password ) = ( 'test', 'test' );
my $client = Regru::API->new( username => $username, password => $password );

ok( $client->domain->nop->is_success, 'domain/nop API call test' );
my $prices = $client->domain->get_prices->get('prices');
isa_ok( $prices, 'HASH', 'Prices type test' );
ok( $prices->{ru}->{reg_price},
    'domain/get_prices ru/reg_price exists test' );

my $suggestions
    = $client->domain->get_suggest( word => 'дом', tld => 'рф' );
ok( $suggestions->is_success, 'domain/get_suggest API call test' );
ok( $suggestions->get('suggestions') );

my $premium = $client->domain->get_premium( tld => 'рф', limit => 5 );
ok( $premium->is_success, 'domain/get_premium API call test' );

my $check_result = $client->domain->check( dname => 'ya.ru' );
ok( $check_result->is_success, 'domain/check API call test' );
isa_ok( $check_result->get('domains'), 'ARRAY', 'Domains type test' );
is( $check_result->get('domains')->[0]->{result},
    'Available', 'domain/check API call answer test' );

my $wrong_check_result = $client->domain->check( dname => 'wwww.ww' );
ok( $wrong_check_result->is_success,
    'domains/check with invalid params API call test' );
is( $wrong_check_result->get('domains')->[0]->{error_code},
    'INVALID_DOMAIN_NAME_FORMAT',
    'domain/check with invalid params; error code test' );

my $jsondata = {
    contacts => {
        descr    => 'Vschizh site',
        person   => 'Svyatoslav V Ryurik',
        person_r => 'Рюрик Святослав Владимирович',
        passport =>
            '22 44 668800 выдан по месту правления 01.09.1164',
        birth_date => '01.01.1970',
        p_addr =>
            '12345, г. Вщиж, ул. Княжеска, д.1, Рюрику Святославу Владимировичу, князю Вщижскому',
        phone   => '+7 495 5555555',
        e_mail  => 'test@reg.ru',
        country => 'RU',
    },
    nss => {
        ns0 => 'ns1.reg.ru',
        ns1 => 'ns2.reg.ru',
    },
    domain_name => 'vschizh.su',
};



# my $domain_create_answer = $client->domain->create(%$jsondata);
# die Dumper $domain_create_answer;

 # "error_params" : {
 #      "error_detail" : {
 #         "e_mail" : {
 #            "error_text" : "No such email address",
 #            "error_code" : "VALUE_INVALID"
 #         },
 #         "passport" : {
 #            "error_text" : "Passport is specified in incorrect format for the given country",
 #            "error_code" : "VALUE_INVALID"
 #         },
 #         "birth_date" : {
 #            "error_text" : "Birth date is specified incorrectly",
 #            "error_code" : "VALUE_INVALID"
 #         },
 #         "phone" : {
 #            "error_text" : "Value of &laquo;Phone&raquo; field is incorrect",
 #            "error_code" : "VALUE_INVALID"
 #         }
 #      }
 #   },


done_testing();
