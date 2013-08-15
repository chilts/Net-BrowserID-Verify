# Copyright (c) 2013 Mozilla.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

package Net::BrowserID::Verify;
use Mouse; # use strict/warnings
use Carp;
use Exporter qw(import);

use LWP::UserAgent;
use JSON::Any;
use HTTP::Request::Common qw(POST);

our @EXPORT_OK = qw(verify_remotely);
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

sub verify_remotely {
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

=pod

=head1 NAME

Net::BrowserID::Verify - Verify BrowserID assertions.

=head1 SYNOPSIS

  # Procedural API
  use Net::BrowserID::Verify qw(verify_remotely);
  my $data = verify_remotely('assertion', 'audience');

  # OO API
  use Net::BrowserID::Verify;
  my $verifier = Net::BrowserID::Verify->new({
      type     => q{remote},
      audience => q{http://localhost},
  });

  my $data = $verifier->verify('assertion');

=head1 CHECK DATA

Once you have $data from the verifier, you can then check if the status was okay.

  if ( $data->{status} eq 'okay' ) {
      # read $data->{email} to set up/login your user
      print $data->{email};
  }
  else {
      # something went wrong with the verification or the request
      print $data->{reason};
  }

=head1 DESCRIPTION

The assertion format you receive when using Persona/BrowserID needs to be
sent from your browser to the server and verified there. This library
helps you verify that the assertion is correct.

The data returned by C<verify_emotely()>, (eventually) C<verify_locally()> or
C<$verifier-E<gt>verify()> contains the following fields:

=over 4

=item * status

The status of the verification. Either 'okay' or 'failure'.

=item * email

The email address which has been verified.

Provided only when status is 'okay'.

=item * issuer

The issuer/identity provider, which should be either the domain of the
email address being verified, or the fallback IdP.

Provided only when status is 'okay'.

=item * expires

The expiry (in ms from epoch). e.g. 1354217396705.

Provided only when status is 'okay'.

=item * audience

The audience you passed to the verifier.

Provided only when status is 'okay'.

=item * reason

Gives the reason why something went wrong.

Only provided if the status is 'failure'.

=back

=head1 AUTHOR

Andrew Chilton "chilts@mozilla.com"

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2013 Mozilla.

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

=cut
