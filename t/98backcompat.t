#!/usr/bin/perl -w

use strict;

use Test::More tests => 2;

package OneOfParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   $self->one_of(
      sub { [ int => $self->token_int ] },
      sub { [ str => $self->token_string ] },
   );
}

package main;

my $parser = OneOfParser->new;

is_deeply( $parser->from_string( "123" ), [ int => 123 ], 'one_of integer' );
is_deeply( $parser->from_string( q["hi"] ), [ str => "hi" ], 'one_of string' );
