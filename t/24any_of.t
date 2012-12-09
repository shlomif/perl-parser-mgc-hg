#!/usr/bin/perl -w

use strict;

use Test::More tests => 6;

package TestParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   $self->any_of(
      sub { [ int => $self->token_int ] },
      sub { [ str => $self->token_string ] },
      sub { [ ident => $self->token_ident ] },
      sub { $self->expect( "@" ); die "Here I fail\n" },
   );
}

package main;

my $parser = TestParser->new;

is_deeply( $parser->from_string( "123" ), [ int => 123 ], '"123"' );
is_deeply( $parser->from_string( q["hi"] ), [ str => "hi" ], '"hi"' );
is_deeply( $parser->from_string( "foobar" ), [ ident => "foobar" ], '"foobar"' );

ok( !eval { $parser->from_string( "@" ) }, '"@" fails' );
is( $@, "Here I fail\n", 'Exception from "@" failure' );

ok( !eval { $parser->from_string( "+" ) }, '"+" fails' );
