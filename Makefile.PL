use 5.008009;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Regru::API',
    AUTHOR        => q{Polina Shubina <shubina@reg.ru>},
    VERSION_FROM  => 'lib/Regru/API.pm',
    ABSTRACT_FROM => 'lib/Regru/API.pm',
    LICENSE       => 'perl',
    META_MERGE    => {
        resources =>
            { repository => 'https://github.com/regru/regru-api-perl', },
    },
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.008009,
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => {
        'Test::More'                    => '0.98',
        'Test::Fatal'                   => '0.010',
        'Test::Pod'                     => '1.22',
    },
    PREREQ_PM          => {
        "strict"                        => 0,
        "warnings"                      => 0,
        "Carp"                          => 0,
        "Data::Dumper"                  => 0,
        "JSON"                          => 0,
        "LWP::UserAgent"                => 0,
        "Moo"                           => 0,
        "Class::Load"                   => 0,
        "Try::Tiny"                     => 0,
        "LWP::Protocol::https"          => 0,
        'Moose'                         => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Regru-API-*' },
);
