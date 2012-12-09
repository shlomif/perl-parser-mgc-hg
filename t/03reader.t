#!/usr/bin/perl -w

use strict;

use Test::More tests => 1;

package TestParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   my @tokens;
   push @tokens, $self->expect( qr/[a-z]+/ ) while !$self->at_eos;

   return \@tokens;
}

package main;

my $parser = TestParser->new;

my @strings = (
   "here is a list ",
   "of some more ",
   "tokens"
);

is_deeply( $parser->from_reader( sub { return shift @strings } ),
   [qw( here is a list of some more tokens )],
   'tokens from reader' );
