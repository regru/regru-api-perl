# NAME

Regru::API - perl client for reg.ru API 2.

# VERSION

Version 0.01

# SYNOPSYS

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop; # makes call for L<https://www.reg.ru/support/help/API-version2#nop>

    if ($response->is_success) {
        say $response->get('user_id');
    }
    else {
        die "Error code: " . $response->error_code . ", Error text: " . $response->error_text;
    }



# DESCRIPTION

API calls are divided into categories - user, domain, zone, user, folder, bill, service. 
Each category is stored in it's own namespace, and can be accessed through
`$client->$namespace` method. For example,
    

    $client->user->nop

makes call to user/nop API method [https://www.reg.ru/support/help/API-version2\#user\_nop](https://www.reg.ru/support/help/API-version2\#user\_nop)

Complete Reg.ru API 2 Documentation can be found here: [https://www.reg.ru/support/help/API-version2](https://www.reg.ru/support/help/API-version2).

All API methods return [Regru::API::Response](http://search.cpan.org/perldoc?Regru::API::Response) object.

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



__NB__: All input params for call are passed in JSON format.

To get service answer, use `$response->get($param_name)` method. `$param_name` is the answer field. 

# SUBROUTINES/METHODS

## new

    my $client = Regru::API->new(username => 'test', password => 'test');
    my $response = $client->nop;
    # another cool code here...

    # and without authentication:
    my $client = Regru::API->new;

    my $response = $client->user->nop; # user/nop doesn't require authentication
    say 'ok' if $response->is_success;



Another options for new():

- lang

    Sets language for error messages.

        my $client = Regru::API->new(username => 'test1', password => 'test', lang => 'ru');
        print $client->nop->error_text; # will print "Ошибка аутентификации по паролю"



- io\_encoding



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

- debug
    

    Debug messages will be printed to STDERR.
        

        my $client = Regru::API->new(debug => 1);


# Error processing

If API returned exception or some bad error, such as 500 internal server error has happened, 
`$response` will store error information and raw HTTP::Response object with service answer.

## is_success

Returns 1 if API call is succeeded, 0 otherwise.

## error_text

Returns error text if an error occured, default language for error messages is english.
Language can be set in Regru::API constructor with C<lang> option.

## error_code

Returns error code if an error occured. Full list error codes list is available at L<https://www.reg.ru/support/help/API-version2#std_error_codes>.

## error_params

Params for error text. 
    
## response

Returns raw HTTP::Response object for further processing.

Sample:

    my $response = $client->api->nop;
    if ($response->is_success) {
        # do some stuff
    }
    else {
        print "Error: " . $response->error_code . ", " . $response->error_text;
    }


# AUTHOR

Polina Shubina, `<shubina@reg.ru>`

# BUGS

Please report any bugs or feature requests to `bug-regru-api at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regru-API](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Regru-API).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.



# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Regru::API


You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regru-API](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Regru-API)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Regru-API](http://annocpan.org/dist/Regru-API)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Regru-API](http://cpanratings.perl.org/d/Regru-API)

- Search CPAN

    [http://search.cpan.org/dist/Regru-API/](http://search.cpan.org/dist/Regru-API/)



# ACKNOWLEDGEMENTS


# LICENSE AND COPYRIGHT

Copyright 2013 Polina Shubina.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic\_license\_2\_0)

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


