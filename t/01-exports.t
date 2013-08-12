#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify qw(verifyRemotely);

diag( "Testing exported functions are exported" );

# check we can see verifyRemotely
can_ok(__PACKAGE__, 'verifyRemotely');

# when we add local verification
#TODO: {
#    can_ok(__PACKAGE__, 'verifyLocally');
#}

done_testing();
