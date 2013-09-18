use 5.006;
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
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => { 'Test::More' => 0, },
    PREREQ_PM          => {
        "Carp"            => 0,
        "Data::Dumper"    => 0,
        "JSON"            => 0,
        "LWP::UserAgent"  => 0,
        "List::MoreUtils" => 0,
        "Moo"             => 0,
        "Net::Ping"       => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Regru-API-*' },
);
