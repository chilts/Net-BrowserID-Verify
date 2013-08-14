#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify qw(verifyRemotely);

diag( "Testing a simple failure case with the hosted remote verifier (procedure)" );
my $data1 = verifyRemotely('assertion', 'audience', {
    # From: https://onlinessl.netlock.hu/en/test-center/invalid-ssl-certificate.html
    url => 'https://tv.eurosport.com/',
});
is($data1->{status}, q{failure}, q{The verification failed});
is($data1->{reason}, q{Can't connect to tv.eurosport.com:443 (certificate verify failed)}, q{SSL cert couldn't be verified});

done_testing();
