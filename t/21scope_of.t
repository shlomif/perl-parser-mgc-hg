#!/usr/bin/perl -w

use strict;

use Test::More tests => 6;

package TestParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   $self->scope_of(
      "(",
      sub { return $self->token_int },
      ")"
   );
}

package DynamicDelimParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   my $delim = $self->expect( qr/[\(\[]/ );
   $delim =~ tr/([/)]/;

   $self->scope_of(
      undef,
      sub { return $self->token_int },
      $delim,
   );
}

package main;

my $parser = TestParser->new;

is( $parser->from_string( "(123)" ), 123, '"(123)"' );

ok( !eval { $parser->from_string( "(abc)" ) }, '"(abc)"' );
ok( !eval { $parser->from_string( "456" ) }, '"456"' );

$parser = DynamicDelimParser->new;

is( $parser->from_string( "(45)" ), 45, '"(45)"' );
is( $parser->from_string( "[45]" ), 45, '"[45]"' );

ok( !eval { $parser->from_string( "(45]" ) }, '"(45]" fails' );
