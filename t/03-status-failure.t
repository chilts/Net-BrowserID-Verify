#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify qw(verifyRemotely);

diag( "Testing a simple failure case with the hosted remote verifier (procedure)" );
my $data1 = verifyRemotely('assertion', 'audience');
is($data1->{status}, 'failure', 'The verification failed');
is($data1->{reason}, 'no certificates provided', "Didn't provide a certificate");

diag( "Testing a simple failure case with the hosted remote verifier (using OO)" );
my $verifier = Net::BrowserID::Verify->new({
    type => 'remote',
    audience => 'http://localhost',
});
my $data2 = $verifier->verify('assertion');
is($data2->{status}, 'failure', 'The verification failed');
is($data2->{reason}, 'no certificates provided', "Didn't provide a certificate");

done_testing();
