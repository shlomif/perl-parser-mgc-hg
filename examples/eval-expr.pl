#!/usr/bin/perl

use strict;
use warnings;

package ExprParser;
use base qw( Parser::MGC );

sub parse
{
   my $self = shift;

   $self->parse_term;
}

sub parse_term
{
   my $self = shift;

   my $val = $self->parse_factor;

   1 while $self->any_of(
      sub { $self->expect( "+" ); $self->commit; $val += $self->parse_factor; 1 },
      sub { $self->expect( "-" ); $self->commit; $val -= $self->parse_factor; 1 },
      sub { 0 },
   );

   return $val;
}

sub parse_factor
{
   my $self = shift;

   my $val = $self->parse_atom;

   1 while $self->any_of(
      sub { $self->expect( "*" ); $self->commit; $val *= $self->parse_atom; 1 },
      sub { $self->expect( "/" ); $self->commit; $val /= $self->parse_atom; 1 },
      sub { 0 },
   );

   return $val;
}

sub parse_atom
{
   my $self = shift;

   $self->any_of(
      sub { $self->scope_of( "(", sub { $self->commit; $self->parse }, ")" ) },
      sub { $self->token_int },
   );
}

if( !caller ) {
   my $parser = __PACKAGE__->new;

   while( defined( my $line = <STDIN> ) ) {
      my $ret = eval { $parser->from_string( $line ) };
      print $@ and next if $@;

      print "$ret\n";
   }
}

1;
