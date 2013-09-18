use strict;
use warnings;
use Test::More tests => 3;
use Regru::API;

sub namespace_client {
    Regru::API->new(username => 'test', password => 'test')->folder;
};

subtest 'Generic behaviour' => sub {
    plan tests => 2;

    my @methods = qw(
        nop
        create
        remove
        rename
        get_services
        add_services
        remove_services
        replace_services
        move_services
    );

    my $client = namespace_client();

    isa_ok $client, 'Regru::API::Folder';
    can_ok $client, @methods;
};

subtest 'Namespace methods (nop)' => sub {
    plan tests => 1;

    my $client = namespace_client();

    my $resp;

    # /folder/nop
    $resp = $client->nop(folder_name => 'qqq');
    ok $resp->is_success,                                   'nop() success';
};

subtest 'Namespace methods (overall)' => sub {
    unless ($ENV{REGRU_API_OVERALL_TESTING}) {
        diag 'Skipped. Set REGRU_API_OVERALL_TESTING=1 to proceed this subtest.';
        plan skip_all => '.';
    }
    else {
        plan tests => 8;
    }

    my $client = namespace_client();

    my $resp;

    # /folder/{create,remove,rename,get_services}
    foreach my $method (qw/create remove rename get_services/) {
        $resp = $client->$method(folder_name => 'qqq');
        ok $resp->is_success, "${method}() success";
    }

    # /folder/{get_services,remove_services,replace_services,move_services}
    foreach my $method (qw/get_services remove_services replace_services move_services/) {
        $resp = $client->$method(
            folder_name => 'qqq',
            services    => [ { dame => 'qqq.ru' } ]
        );
        ok $resp->is_success, "${method}() success";
    }
};

1;
