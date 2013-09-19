#!perl -T

use strict;
use warnings FATAL => 'all';
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
    if $@;

# all_pod_coverage_ok();
pod_coverage_ok('Regru::API', { trustme => [qr/^bill|domain|folder|method|service|user|zone/]});
pod_coverage_ok('Regru::API::Response', { trustme => [qr/^answer|raw_content|BUILD/]});

done_testing();

1;
