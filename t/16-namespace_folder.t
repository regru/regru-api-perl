use Test::More;
use Net::Ping;
use Regru::API;
my $client = Regru::API->new( username => 'test', password => 'test' );

plan skip_all => "Internet connection problem"
    unless Net::Ping->new->ping('reg.ru');

ok( $client->folder->nop( folder_name => 'qqq' )->is_success,
    'folder/nop API call test' );

SKIP: {
    skip "For calling all API functions set ALL_TEST env var to 1", 8
        unless $ENV{ALL_TESTS};

    for my $method (qw/create remove rename get_services/) {
        ok( $client->folder->$method( folder_name => 'qqq' )->is_success,
            "folder/$method API call test" );

    }

    for my $method (
        qw/get_services remove_services replace_services move_services/)
    {
        ok( $client->folder->$method(
                folder_name => 'qqq',
                services    => [ { dame => 'qqq.ru' } ]
                )->is_success,
            "folder/$method API call test"
        );

    }
}

done_testing();
