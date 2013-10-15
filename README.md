# NAME

Regru::API - Perl bindings for Reg.ru API v2

[![build status](https://secure.travis-ci.org/regru/regru-api-perl.png)](https://travis-ci.org/regru/regru-api-perl)

# VERSION

version 0.042

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

Regru::API implements simplified access to the REG.API v2 provided by REG.RU LLC. This is a JSON-driven implementation.
Input/output request data will transforms from/to JSON transparently.

## Rate limiting

Rate limiting in version 2 of the REG.API is considered on a per-user and per-ip basic. The REG.API methods have not
divided into groups by limit level. There is no difference between them. At the moment REG.API v2 allows to execute
`1200` requests per-user and per-ip within `1 hour` window. Both limits are acting at the same time.
If the limits has exceeded then REG.API sets the error code (depends on kind of) to `IP_EXCEEDED_ALLOWED_CONNECTION_RATE` or
`ACCOUNT_EXCEEDED_ALLOWED_CONNECTION_RATE` which might be checked via attribute [error\_code](http://search.cpan.org/perldoc?Regru::API::Response#error\_code).

The following tips are there might helps to reduce the possibility of being rate limited:

- __Caching__

    Store all domain name or service related data locally and use the REG.API in cases you want to change some data in
    the registry (e.g. contact data, DNS servers, etc).

- __Bulk requests__

    Group similar items and execute a bulk API request. A bunch of methods supports sending request for the list of items at
    the same time (e.g. multiple domain names). Check the details at
    [REG.API Service list identification parameters](https://www.reg.com/support/help/API-version2\#inputparams\_identification\_multi).

- __Journaling__

    Keep the logs of interactions with REG.API (requests and responses). This will helps quickly resolve the issues
    instead of sending additional requests to find out what's happened.

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
        $client->bill->get_not_payed(
            limit => 10,
        );

    See [Regru::API::Bill](http://search.cpan.org/perldoc?Regru::API::Bill) for details and
    [REG.API Invoice management functions](https://www.reg.com/support/help/API-version2\#bill\_fn).

## Methods accessibility

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

## Request parameters

Each API request should contains a set of parameters. There are the following parameters:

- __authentication parameters__

    These parameters are mandatory for the each method that requires authentication. This group of parameters includes
    `username` and `password`. Both parameters should be passed to the [constructor](#new) and their will be added
    to API request.

- __management parameters__

    This group include parameters defines input/output formats, encodings and language prefecence. Some parameters are fixed to
    certains values, some might be set via passing values to the [constructor](#new): see `io_encoding` and `lang` options.

- __service identification parameters__

    The group of parameters with aims to point to the particular service or group of services such as domain names,
    folders, etc. Should be passed to an API request together with `method specific parameters`.

    More info at
    [REG.API Service identification parameters](https://www.reg.com/support/help/API-version2\#inputparams\_identification)

- __method specific parameters__

    Parameters applicable to a particular API method. Very wide group. Strongly recommended to consult with REG.API documentation
    for each method before perform an API request to it. The distribution's manual pages includes links to documentation
    for each API method call. The main source for the method specific parameters available at
    [REG.API General description of functions](https://www.reg.com/support/help/API-version2\#common\_fn\_descr).

## Response parameters

Response parameters of the API request automatically handles by [Regru::API::Response](http://search.cpan.org/perldoc?Regru::API::Response) module. There is no reasons to
do some addtional work on them. Each response may contains the following set of fileds:

- __result__

    The result of API request. Either `success` or `error`. Can be accessed via attribute
    [is\_success](http://search.cpan.org/perldoc?Regru::API::Response#is\_success) in boolean context.

- __answer__

    The answer of API method call. May appear only when result of API request was successful. Can be accessed via attribute
    [answer](http://search.cpan.org/perldoc?Regru::API::Response#answer). Default value is `{}` (empty HashRef). Gets assigned a default value if
    result of API request was finished with error.

- __error\_code__

    The error code of API method call. May appear only when result of API request finished with error. Can be accessed via
    attribute [error\_code](http://search.cpan.org/perldoc?Regru::API::Response#error\_code).
    See details at [REG.API Common error codes](https://www.reg.com/support/help/API-version2\#std\_error\_codes).

- __error\_text__

    The short description of error. The language depends on option lang ["new"](#new) passed to constructor. May appear only when result
    of API request finished with error. Can be accessed via attribute [error\_text](http://search.cpan.org/perldoc?Regru::API::Response#error\_text).
    See details at [REG.API Common error codes](https://www.reg.com/support/help/API-version2\#std\_error\_codes).

- __error\_params__

    Additional parameters included to the error. May appear only when result of API request finished with error. Can be accessed
    via attribute [error\_params](http://search.cpan.org/perldoc?Regru::API::Response#error\_params).

## Access to REG.API in test mode

REG.RU LLC provides an access to REG.API in test mode. For this, might be used a test account with `username` and `password`
equals to __test__.

    my $client = Regru::API->new(username => 'test', password => 'test');
    # we're in test mode now
    $client->domain->get_prices;

In the test mode REG.API engine (at server-side) handles API request: ensures necessary checks of input parameters,
produces response but actually does not perform any real actions/changes.

Also, for debugging purposes REG.API provides a special set of methods allows to ensure the remote system for availability
without workload at minimal response time. Each namespace has method called __nop__ for that.

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
    supports the following encodings: `utf8`, `cp1251`, `koi8-r`, `koi8-u`, `cp866`. Optional. Default value is __utf8__.

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
    `en` (English), `ru` (Russian) and `th` (Thai). Optional. Default value is __en__.

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

## user

Returns a handler to access to REG.API user account management methods. See [Regru::API::User](http://search.cpan.org/perldoc?Regru::API::User).

## domain

Returns a handler to access to REG.API domain name management methods. See [Regru::API::Domain](http://search.cpan.org/perldoc?Regru::API::Domain).

## zone

Returns a handler to access to REG.API DNS resource records management methods. See [Regru::API::Zone](http://search.cpan.org/perldoc?Regru::API::Zone).

## service

Returns a handler to access to REG.API service management methods. See [Regru::API::Service](http://search.cpan.org/perldoc?Regru::API::Service).

## folder

Returns a handler to access to REG.API folder management methods. See [Regru::API::Folder](http://search.cpan.org/perldoc?Regru::API::Folder).

## bill

Returns a handler to access to REG.API invoice management methods. See [Regru::API::Bill](http://search.cpan.org/perldoc?Regru::API::Bill).

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

# SEE ALSO

[Regru::API::Bill](http://search.cpan.org/perldoc?Regru::API::Bill)

[Regru::API::Domain](http://search.cpan.org/perldoc?Regru::API::Domain)

[Regru::API::Folder](http://search.cpan.org/perldoc?Regru::API::Folder)

[Regru::API::Service](http://search.cpan.org/perldoc?Regru::API::Service)

[Regru::API::User](http://search.cpan.org/perldoc?Regru::API::User)

[Regru::API::Zone](http://search.cpan.org/perldoc?Regru::API::Zone)

[Regru::API::Response](http://search.cpan.org/perldoc?Regru::API::Response)

[REG.API Common functions](https://www.reg.com/support/help/API-version2\#tests\_fn)

[REG.API Common error codes](https://www.reg.com/support/help/API-version2\#std\_error\_codes)

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
