#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify qw(verifyRemotely);

my $data = verifyRemotely('assertion', 'audience');

# is($data, 'HASH', '$data is a hash');
is($data->{status}, 'failure', 'The verification failed');
is($data->{reason}, 'no certificates provided', "Didn't provide a certificate");

done_testing();