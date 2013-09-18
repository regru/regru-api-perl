use Test::More;
use Regru::API;
use utf8;
use Data::Dumper;
use Net::Ping;


my ( $username, $password ) = ( 'test', 'test' );
my $client = Regru::API->new( username => $username, password => $password );

plan skip_all => "Internet connection problem"
        unless Net::Ping->new->ping('reg.ru');

ok( $client->domain->nop->is_success, 'domain/nop API call test' );

SKIP: {

    skip "For calling all API functions set ALL_TEST env var to 1", 9
        unless $ENV{ALL_TESTS};

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
        'domain/check with invalid params; error code test'
    );

    my $jsondata = {
        contacts => {
            descr  => 'Vschizh site',
            person => 'Svyatoslav V Ryurik',
            person_r =>
                'Рюрик Святослав Владимирович',
            passport =>
                '34 02 651241 выдан 48 о/м г.Москвы 26.12.1999',
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

    my $domain_create_answer = $client->domain->create(%$jsondata);
    ok( $domain_create_answer->is_success, 'domain/create API call test' );
    is( $domain_create_answer->get('bill_id'),
        '1234', 'domain/create bill id test' );

    $jsondata = {
        contacts => {
            descr  => 'Vschizh site',
            person => 'Svyatoslav V Ryurik',
            person_r =>
                'Рюрик Святослав Владимирович',
            passport =>
                '22 44 668800, выдан по месту правления 01.09.1999',
            birth_date => '01.01.1980',
            p_addr =>
                '12345, г. Вщиж, ул. Княжеска, д.1, Рюрику Святославу Владимировичу, князю Вщижскому',
            phone   => '+7 495 8102233',
            e_mail  => 'test@reg.ru',
            country => 'RU',
        },
        nss => {
            ns0 => 'ns1.reg.ru',
            ns1 => 'ns2.reg.ru',
        },
        domains => [
            {   dname           => 'vschizh.ru',
                srv_certificate => 'free',
                srv_parking     => 'free'
            },
            { dname => 'vschizh.su', srv_webfwd => '' },
        ],
    };

    my $multiple_domains_create_answer = $client->domain->create(%$jsondata);
    ok( $multiple_domains_create_answer->is_success,
        'domain/create (multiple) API call test'
    );

    is( $multiple_domains_create_answer->get('bill_id'),
        1234, 'domain/create bill_id test (multiple)' );
    my $domains = $multiple_domains_create_answer->get('domains');
    is( scalar @$domains, 2, 'multiple domains total count test' );

    my $domain_transfer_answer
        = $client->domain->transfer( authinfo => '1231234563454' );

    is( $domain_transfer_answer->error_code, 'DOMAINS_NOT_FOUND' );

    $jsondata = {
        contacts => {
            descr  => 'Vschizh site',
            person => 'Svyatoslav V Ryurik',
            person_r =>
                'Рюрик Святослав Владимирович',
            passport =>
                '22 44 668800, выдан по месту правления 01.09.1999',
            birth_date => '01.01.1980',
            p_addr =>
                '12345, г. Вщиж, ул. Княжеска, д.1, Рюрику Святославу Владимировичу, князю Вщижскому',
            phone   => '+7 495 8102233',
            e_mail  => 'test@reg.ru',
            country => 'RU',
        },
        nss => {
            ns0 => 'ns1.reg.ru',
            ns1 => 'ns2.reg.ru',
        },
        domains => [
            { dname => 'vschizh.ru', price => 225 },

# или заказ в рассрочку: { dname => 'vschizh.ru', price => 2500, instalment => 1 },
            { dname => 'vschizh.su', price => 400 },
        ],
    };

    ok( $client->domain->set_rereg_bids(%$jsondata)->is_success,
        'domain/set_rereg_bids API call test' );
    ok( $client->domain->get_user_rereg_bids->is_success,
        'domain/get_user_rereg_bids API call test'
    );
    ok( $client->domain->get_docs_upload_uri( dname => 'test.ru' )
            ->is_success,
        'domain/get_docs_upload_uri API call test'
    );

    my $update_private_person_flag_answer
        = $client->domain->update_private_person_flag(
        private_person_flag => 0,
        dname               => 'test.ru'
        );
    ok( $update_private_person_flag_answer->is_success,
        'domain/update_private_person_flag API call test'
    );
    is( $update_private_person_flag_answer->get('pp_flag'),
        'is cleared', 'domain/update_private_person_flag answer test' );
    ok( $client->domain->register_ns(
            dname => 'test.com',
            ns0   => 'ns0.test.com'
            )->is_success,
        'domain/register_ns API call test'
    );

    ok( $client->domain->delete_ns(
            dname => 'test.com',
            ns0   => 'ns0.teset.com'
            )->is_success,
        'domain/delete_ns API call test'
    );

    ok( $client->domain->get_nss( dname => 'test.com' )->is_success,
        'domain/get_nss API call test' );

    ok( $client->domain->update_nss(
            domains => [ { dname => 'test.ru' } ],
            nss => { 'ns0' => 'ns1.reg.ru', ns1 => 'ns2.reg.ru' }
            )->is_success,
        'domain/update_nss API call test'
    );

    ok( $client->domain->delegate( domains => [ { dname => 'test.ru' } ] )
            ->is_success,
        'domain/delegate API call test'
    );

    ok( $client->domain->undelegate( domains => [ { dname => 'test.ru' } ] )
            ->is_success,
        'domain/undelegate API call test'
    );

    ok( $client->domain->transfer_to_another_account(
            domains       => [ { dname => 'test.ru' } ],
            new_user_name => 'not_test'
            )->is_success,
        'domain/transfer_to_another_account API call test'
    );

    # ok( $client->domain->look_at_entering_list->is_success,
    #     'domain/look_at_entering_list API call test'
    # );

    # die Dumper ($client->domain->look_at_entering_list);

    # ok( $client->domain->accept_or_refuse_entering_list->is_success,
    #     'domain/accept_or_refuse_entering_list API call test'

    # );

    ok( $client->domain->cancel_transfer( dname => 'test.ru' ),
        'domain/cancel_transfer API call test' );
    ok( $client->domain->request_to_transfer(
            domains =>
                [ { domain_name => 'test.ru' }, { dname => 'test.ru' } ]
        ),
        'domain/request_to_transfer API call test'
    );

}

done_testing();
