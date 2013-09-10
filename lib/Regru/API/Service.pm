package Regru::API::Service;

use Modern::Perl;

use Moo;
extends 'Regru::API::NamespaceHandler';

my @methods
    = qw/nop get_prices get_servtype_details create delete get_info get_list get_folders
    get_details service_get_details get_dedicated_server_list update renew get_bills
    set_autorenew_flag suspend resume get_deprecated_period upgrade partcontrol_grant
    partcontrol_revoke resend_mail/;

has '+methods' => ( is => 'ro', default => sub { \@methods } );
has '+namespace' => ( default => sub {'service'} );

1;