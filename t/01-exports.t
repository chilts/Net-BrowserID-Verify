#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify qw(verifyRemotely);

# check we can see verifyRemotely
can_ok(__PACKAGE__, 'verifyRemotely');

# ToDo: when we add local verification
# can_ok(__PACKAGE__, 'verifyLocally');

done_testing();
