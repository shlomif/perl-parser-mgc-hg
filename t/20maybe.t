#!/usr/bin/perl -w

use strict;

use Test::More tests => 4;

my $die;

package TestParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   $self->maybe( sub {
      die $die if $die;
      $self->token_ident;
   } ) ||
      $self->token_int;
}

package main;

my $parser = TestParser->new;

is( $parser->from_string( "hello" ), "hello", '"hello"' );
is( $parser->from_string( "123" ), 123, '"123"' );

$die = "Now have to fail\n";
ok( !eval { $parser->from_string( "456" ) }, '"456" with $die fails' );
is( $@, "Now have to fail\n", 'Exception from failure' );
