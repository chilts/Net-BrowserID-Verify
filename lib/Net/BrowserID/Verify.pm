package Net::BrowserID::Verify;

=head1 NAME

Net::BrowserID::Verify - Verify BrowserID assertions.

=cut

package Net::BrowserID::Verify;
use Mouse; # use strict/warnings
use Carp;
use vars '$VERSION';
use Exporter qw(import);

use LWP::UserAgent;
use JSON::Any;
use HTTP::Request::Common qw(POST);

our @EXPORT_OK = qw(verifyRemotely);
our $VERSION = '0.001';
my $REMOTE_VERIFIER = 'https://verifier.login.persona.org/verify';

my $json = JSON::Any->new;

has type     => ( is => 'ro', isa => 'Str', default => 'remote' );
has audience => ( is => 'ro', isa => 'Str' );
has url      => ( is => 'ro', isa => 'Str', default => $REMOTE_VERIFIER );
has ua       => ( is => 'ro', builder => 'make_ua' );

sub make_ua {
    my $ua = LWP::UserAgent->new();
    $ua->ssl_opts( verify_hostname => 1 );
    return $ua;
}

sub verify {
    my ($self, $assertion) = @_;

    my $req = POST $self->url, [ audience => $self->audience, assertion => $assertion ];
    my $resp = $self->ua->request($req);

    my $data;

    if ($resp->is_success) {
        my $message = $resp->decoded_content;
        $data = $json->decode($message);
    }
    else {
        $data = {
            status => 'failure',
            reason => $resp->message,
        };
    }

    return $data;

}

# now, set up some vars we can use in the rest of the file
# my $ua = LWP::UserAgent->new();

# always check the SSL certs
# $ua->ssl_opts( verify_hostname => 1 );

# Call this as follows:
#
# my $data = verifyRemotely($assertion, $audience, { ... });
#
sub verifyRemotely {
    my ($assertion, $audience, $opts) = @_;

    my $verifier = Net::BrowserID::Verify->new({
        type     => q{remote},
        audience => $audience,
        url      => $opts->{url} || $REMOTE_VERIFIER,
    });

    return $verifier->verify('assertion');
}

1;

__END__
