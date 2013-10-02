package t::lib::NamespaceClient;

# ABSTRACT: A helper that creates client instance

use strict;
use warnings;
use Regru::API;

sub root {
    my $class = shift;

    Regru::API->new(
        username => 'test',
        password => 'test',
    );
}

sub user    { $_[0]->root->user;     }
sub domain  { $_[0]->root->domain;   }
sub zone    { $_[0]->root->zone;     }
sub service { $_[0]->root->service;  }
sub folder  { $_[0]->root->folder;   }
sub bill    { $_[0]->root->bill;     }


1; # End of t::lib::NamespaceClient

__END__
