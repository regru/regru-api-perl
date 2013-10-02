# NAME

Regru::API - Perl bindings for Reg.ru API v2

[![build status](https://secure.travis-ci.org/regru/regru-api-perl.png)](https://travis-ci.org/regru/regru-api-perl)

# VERSION

version 0.004

# SYNOPSIS

    my $client = Regru::API->new(
        username => 'test',
        password => 'test',
    );

    # trivial API request
    my $resp = $client->nop;

    if ($resp->is_success) {
        print $response->get('user_id');
    }
    else {
        print "Error code: " . $resp->error_code . ", Error text: " . $resp->error_text;
    }

# DESCRIPTION

...

# OVERVIEW

## Categories (namespaces)

REG.API methods are divided into categories (namespaces). When you wish to make an API request to some REG.API method,
that belongs to some namespace (category) you should get a namespace handler (defined as trivial client's method):

    # suppose we already have a client
    $client->user->nop;

    # or like this
    $zone = $client->zone;
    $zone->register_ns(...);

At the moment there are the following namespaces:

- __root__

    General purpose methods such as ["nop"](#nop), ["reseller\_nop"](#reseller\_nop) etc which are described below. Actually is a virtual namespace
    defined by client. No needs to get namespace handler. The methods of this `namespace` are available as client's methods
    directly.

        $client->nop;
        $client->reseller_nop;

    See ["REG.API METHODS"](#REG.API METHODS).

- __user__

    User account management methods.

        # suppose we already have a client
        $client->user->nop;

    See [Regru::API::User](http://search.cpan.org/perldoc?Regru::API::User) for details and
    [REG.API Account management functions](https://www.reg.com/support/help/API-version2\#user\_fn).

- __domain__

    Domain names management methods.

        # suppose we already have a client
        $client->domain->get_nss(
            domain_name => 'gallifrey.ru',
        );

    See [Regru::API::Domain](http://search.cpan.org/perldoc?Regru::API::Domain) for details and
    [REG.API Domain management functions](https://www.reg.com/support/help/API-version2\#domain\_fn).

- __zone__

    DNS resource records management methods.

        # suppose we already have a client
        $client->zone->clear(
            domain_name => 'pyrovilia.net',
        );

    See [Regru::API::Zone](http://search.cpan.org/perldoc?Regru::API::Zone) for details and
    [REG.API DNS management functions](https://www.reg.com/support/help/API-version2\#zone\_fn).

- __service__

    Service management methods.

        # suppose we already have a client
        $client->service->delete(
            domain_name => 'sontar.com',
            servtype    => 'srv_hosting_plesk',
        );

    See [Regru::API::Service](http://search.cpan.org/perldoc?Regru::API::Service) for details and
    [REG.API Service management functions](https://www.reg.com/support/help/API-version2\#service\_fn).

- __folder__

    User folders management methods.

        # suppose we already have a client
        $client->folder->create(
            folder_name => 'UNIT',
        );

    See [Regru::API::Folder](http://search.cpan.org/perldoc?Regru::API::Folder) for details and
    [REG.API Folder management functions](https://www.reg.com/support/help/API-version2\#folder\_fn).

- __bill__

    Invoice management methods.

        # suppose we already have a client
        $client->invoice->get_not_payed(
            limit => 10,
        );

    See [Regru::API::Bill](http://search.cpan.org/perldoc?Regru::API::Bill) for details and
    [REG.API Invoice management functions](https://www.reg.com/support/help/API-version2\#bill\_fn).

## Methods accesibility

All REG.API methods can be divided into categories of accessibility. On manual pages of this distibution accessibility
marked by `scope` tag. At the moment the following categories of accessibility present:

- __everyone__

    All methods tagged by this one are accessible to all users. Those methods does not require authentication before call.

- __clients__

    This tag indicates the methods which accessible only for users registered on [reg.com](https://www.reg.com) website.
    Strongly required an authenticated API request.

- __partners__

    Group of methods which accessible only for partners (resellers) of the REG.RU LLC. Actually, partners (resellers)
    able to execute all methods of the REG.API without any restrictions.

# METHODS

## new

Creates a client instance to interract with REG.API.

    my $client = Regru::API->new(
        username => 'Rassilon',
        password => 'You die with me, Doctor!'
    );

    my $resp = $client->user->get_balance;

    print $resp->get('prepay') if $resp->is_success;

    # another cool code...

Available options:

- __username__

    Account name of the user to access to [reg.com](https://www.reg.com) website. Required. Should be passed at instance
    create time. Although it might be changed at runtime.

        my $client = Regru::API->new(username => 'Cyberman', password => 'Exterminate!');
        ...
        # at runtime
        $client->username('Dalek');

- __password__

    Account password of the user to access to [reg.com](https://www.reg.com) website or an alternative password for API
    defined at [Reseller settings](https://www.reg.com/reseller/details) page. Required. Should be passed at instance create time.
    Although it might be changed at runtime.

        my $client = Regru::API->new(username => 'Master', password => 'Doctor');
        ...
        # at runtime
        $client->password('The-Master.');

- __io\_encoding__

    Defines encoding that will be used for data exchange between the Service and the Client. At the moment REG.API v2
    supports the following encodings: _utf8_, _cp1251_, _koi8-r_, _koi8-u_, _cp866_. Optional. Default value is __utf8__.

        my $client = Regru::API->new(..., io_encoding => 'cp1251');
        ...
        # or at runtime
        $client->io_encoding('cp1251');

        my $resp = $client->user->create(
            user_login      => 'othertest',
            user_password   => '111',
            user_email      => 'test@test.ru',
            user_first_name => $cp1251_encoded_name
        );

- __lang__

    Defines the language which will be used in error messages. At the moment REG.API v2 supports the following languages:
    English (_en_), Russian (_ru_) and Thai (_th_). Optional. Default value is __en__.

        my $client = Regru::API->new(..., lang => 'ru');
        ...
        # or at runtime
        $client->lang('ru');

        $client->username('bogus-user');
        print $client->nop->error_text; # -> "Ошибка аутентификации по паролю"

- __debug__

    A few messages will be printed to STDERR. Default value is __0__ (suppressed debug activity).

        my $client = Regru::API->new(..., debug => 1);
        ...
        # or at runtime
        $client->debug(1);

## namespace\_handlers

Creates shortcuts to REG.API categories (namespaces). Used internally.

# REG.API METHODS

## nop

For testing purposes. Scope: __everyone__. Typical usage:

    $resp = $client->nop;

Answer will contains an user\_id and login fields.

More info at [Common functions: nop](https://www.reg.com/support/help/API-version2\#nop).

## reseller\_nop

Similar to previous one but only for partners. Scope: __partners__. Typical usage:

    $resp = $client->reseller_nop;

Answer will contains an user\_id and login fields.

More info at [Common functions: nop](https://www.reg.com/support/help/API-version2\#reseller\_nop).

## get\_user\_id

Get the identifier of the current user. Scope: __clients__. Typical usage:

    $resp = $client->get_user_id;

Answer will contains an user\_id field.

More info at [Common functions: nop](https://www.reg.com/support/help/API-version2\#get\_user\_id).

## get\_service\_id

Get service or domain name identifier by its name. Scope: __clients__. Typical usage:

    $resp = $client->get_service_id(
        domain_name => 'teselecta.ru',
    );

Answer will contains a service\_id field or error code if requested domain name/service not found.

More info at [Common functions: nop](https://www.reg.com/support/help/API-version2\#get\_service\_id).

# Error processing

If API returned exception or some bad error, such as 500 internal server error has happened,
`$response` will store error information and raw [HTTP::Response](http://search.cpan.org/perldoc?HTTP::Response) object with service answer.

## is\_success

Returns 1 if API call is succeeded, 0 otherwise.

## error\_text

Returns error text if an error occured, default language for error messages is english.
Language can be set in Regru::API constructor with `lang` option.

## error\_code

Returns error code if an error occured. Full list error codes list is available at [https://www.reg.com/support/help/API-version2\#std\_error\_codes](https://www.reg.com/support/help/API-version2\#std\_error\_codes).
Error code API\_FAIL means incorrect answer from API, such as 500 internal server error.

## error\_params

Params for error text.

## response

Returns raw [HTTP::Response](http://search.cpan.org/perldoc?HTTP::Response) object for further processing.

Sample:

    my $response = $client->api->nop;
    if ($response->is_success) {
        # do some stuff
    }
    else {
        print "Error: " . $response->error_code . ", " . $response->error_text;
    }

# SEE ALSO

[Regru::API::Bill](http://search.cpan.org/perldoc?Regru::API::Bill)

[Regru::API::Domain](http://search.cpan.org/perldoc?Regru::API::Domain)

[Regru::API::Folder](http://search.cpan.org/perldoc?Regru::API::Folder)

[Regru::API::Service](http://search.cpan.org/perldoc?Regru::API::Service)

[Regru::API::User](http://search.cpan.org/perldoc?Regru::API::User)

[Regru::API::Zone](http://search.cpan.org/perldoc?Regru::API::Zone)

[Regru::API::Response](http://search.cpan.org/perldoc?Regru::API::Response)

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/regru/regru-api-perl/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHORS

- Polina Shubina <shubina@reg.ru>
- Anton Gerasimov <a.gerasimov@reg.ru>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by REG.RU LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
