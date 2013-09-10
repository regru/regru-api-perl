use Test::More;

use Data::Dumper;
use Regru::API;
my $client = Regru::API->new( username => 'test', password => 'test' );

for my $method (qw/nop create remove rename get_services/) {
    ok( $client->folder->$method( folder_name => 'qqq' )->is_success,
        "folder/$method API call test" );

}

for my $method (qw/get_services remove_services replace_services move_services/) {
    ok( $client->folder->$method(
            folder_name => 'qqq',
            services    => [ { dame => 'qqq.ru' } ]
            )->is_success,
        "folder/$method API call test"
    );

}

done_testing();
