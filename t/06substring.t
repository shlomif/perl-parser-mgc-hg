#!/usr/bin/perl -w

use strict;

use Test::More tests => 2;

package TestParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   [ $self->substring_before( "!" ), $self->expect( "!" ) ];
}

package main;

my $parser = TestParser->new;

is_deeply( $parser->from_string( "Hello, world!" ),
   [ "Hello, world", "!" ],
   '"Hello, world!"' );

is_deeply( $parser->from_string( "!" ),
   [ "", "!" ],
   '"Hello, world!"' );
