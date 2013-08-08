package Net::BrowserID::Verify;

=head1 NAME

Net::BrowserID::Verify - Verify BrowserID assertions.

=cut

use strict;
use warnings;
use Carp;
use vars '$VERSION';
use Exporter qw(import);
use LWP::UserAgent;
use JSON::Any;
use HTTP::Request::Common qw(POST);

our @EXPORT_OK = qw(verifyRemotely);

$VERSION = '0.1';

# now, set up some vars we can use in the rest of the file
my $ua = LWP::UserAgent->new();
my $json = JSON::Any->new;

# Call this like:
#
# my $data = verifyRemotely($assertion, $audience, { ... });
#
sub verifyRemotely {
    my ($assertion, $audience, $opts) = @_;

    my $url = $opts->{url} || 'https://verifier.login.persona.org/verify';
    my $proxy = $opts->{proxy};

    my $data;

    # set custom HTTP request header fields
    my $req = POST $url, [ audience => $audience, assertion => $assertion ];
    my $resp = $ua->request($req);

    if ($resp->is_success) {
        my $message = $resp->decoded_content;
        $data = $json->decode($message);
    }
    else {
        carp $resp->code . "-" . $resp->message;
    }

    return $data;
}

1;
__END__
