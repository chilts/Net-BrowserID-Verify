#!perl -T

use strict;
use warnings;

use Test::More;
use Net::BrowserID::Verify;

ok(1, "Successfully loaded Net::BrowserID::Verify via 'use'");

diag( "Testing Net::BrowserID::Verify $Net::BrowserID::Verify::VERSION, Perl $], $^X" );

done_testing();
