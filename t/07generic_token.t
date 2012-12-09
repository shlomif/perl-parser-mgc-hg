#!/usr/bin/perl -w

use strict;

use Test::More tests => 4;

package TestParser;
use base qw( Parser::MGC );

my $re;
my $convert;

sub parse
{
   my $self = shift;

   return $self->generic_token( token => $re, $convert );
}

package main;

my $parser = TestParser->new;

$re = qr/[A-Z]+/;
is( $parser->from_string( "HELLO" ), "HELLO", 'Simple RE' );
ok( !eval { $parser->from_string( "hello" ) }, 'Simple RE fails' );

$re = qr/[A-Z]+/i;
is( $parser->from_string( "Hello" ), "Hello", 'RE with flags' );

$convert = sub { lc $_[1] };
is( $parser->from_string( "Hello" ), "hello", 'Conversion function' );
