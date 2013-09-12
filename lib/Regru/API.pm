package Regru::API;
use v5.10.1;
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils 'any';
use Carp;

use Moo;

my @methods    = qw/nop reseller_nop get_user_id get_service_id/;
my @namespaces = qw/user domain zone bill folder service/;

use Memoize;
memoize('_get_namespace_handler');

{
    # Namespace handlers generation
    no strict 'refs';
    for my $namespace (@namespaces) {
        my $sub_name = 'Regru::API::' . $namespace;
        *{$sub_name} = sub {
            my $self = shift;

            return $self->_get_namespace_handler( $namespace, @_ );
            }
    }
}

extends 'Regru::API::NamespaceHandler';

sub methods {
    return \@methods;
}

__PACKAGE__->_create_methods;

=head1 NAME

=encoding utf8

Regru::API - perl client for reg.ru API 2.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSYS

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop; # makes call for L<https://www.reg.ru/support/help/API-version2#nop>

    if ($response->is_success) {
        say $response->get('user_id');
    }
    else {
        die "Error code: " . $response->error_code . ", Error text: " . $response->error_text;
    }


=head1 DESCRIPTION

API calls are divided into categories - user, domain, zone, user, folder, bill, service. 
Each category is stored in it's own namespace, and can be accessed through
C<$client->$namespace method>. For example,
    
    $client->user->nop

makes call to user/nop API method L<https://www.reg.ru/support/help/API-version2#user_nop>

Complete Reg.ru API 2 Documentation can be found here: L<https://www.reg.ru/support/help/API-version2>.

All API methods return L<Regru::API::Response> object.

    my $response = $client->domain->get_premium;

    if ($response->is_success) {
        # answer params can be get with C<$response->get($param_name)> method
        my $domains = $response->get('domain');
        for my $domain_info (@$domains) {
            say "Name: " . $domain_info->{ name } . ", price: " . $domain_info->{ price };
        }
    }
    else {
        ... 
    }


All params for API call is passed to API method call as a hash;


    my $refill_balance_response = $client->user->refill_balance(
        pay_type => 'WM',
        wmid     => '123456789012',
        currency => 'RUR',
        amount   => 100
    );



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

    my $domain_create_answer = $client->domain->create(%$jsondata);

    if ($domain_create_answer->is_success) {
        say "Domain create request succeeded";
    } 
    else {
        die $domain_create_answer->error_text;
    }


B<NB>: All input params for call are passed in JSON format.

To get service answer, use C<$response->get($param_name)> method. C<$param_name> is the answer field. 

=head1 SUBROUTINES/METHODS

=head2 new

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop;
    # another cool code here...

    # and without authentication:
    my $client = Regru::API->new;

    my $response = $client->user->nop; # user/nop doesn't require authentication
    say 'ok' if $response->is_success;


Another options for new():

=over

=item lang

Sets language for error messages.

    my $client = Regru::API->new(username => 'test1', password => 'test', lang => 'ru');
    print $client->nop->error_text; # will print "Ошибка аутентификации по паролю"


=item io_encoding


Sets encoding for input and output data.

    my $client = Regru::API->new(
        username    => 'test',
        password    => 'test',
        io_encoding => 'cp1251'
    );
    my $response = $client->user->create(
        user_login      => 'othertest',
        user_password   => '111',
        user_email      => 'test@test.ru',
        user_first_name => $cp1251_encoded_name
    );

=item debug
    
Debug messages will be printed to STDERR.
    
    my $client = Regru::API->new(debug => 1);

=back


=cut

sub _get_namespace_handler {
    my $self      = shift;
    my $namespace = shift;

    my $class = 'Regru::API::' . ucfirst($namespace);
    eval qq{require $class};
    croak $@ if $@;
    my %params
        = map { $_ => $self->$_; }
        qw/username password io_encoding lang debug/;
    return $class->new( @_, %params );
}

=head2 nop

Does nothing, for testing purpose. Returns user_id and login for authorized_clients.

    my $response = $client->nop;
    if ($response->is_success) {
        my $user_id = $response->get('user_id');
        my $login = $response->get('login');
    }


=cut

=head1 AUTHOR

Polina Shubina, C<< <shubina at reg.ru> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-regru-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regru-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Regru::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regru-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Regru-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Regru-API>

=item * Search CPAN

L<http://search.cpan.org/dist/Regru-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Polina Shubina.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of Regru::API
