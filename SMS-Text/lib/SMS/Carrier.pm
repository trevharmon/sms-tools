package SMS::Carrier; # Parent Class
our $VERSION = 0.01;

require 5.8.0;
use strict;
use warnings;
use Carp;
use Email::Valid;
use Readonly;

################################################################################
#
our @CARP_NOT = (__PACKAGE__);
#
################################################################################
#
Readonly our $EMAIL_PATTERN  => '%s@example.com';
Readonly our $NUMBER_PATTERN => qr/^\d{10}$/;
#
################################################################################
#
Readonly my $SUCCESS => 1;
Readonly my $FAILURE => 0;
#
################################################################################



#===============================================================================
#
my $_init = sub
{
};
#
#===============================================================================
#
sub new
{

  my $invocant = shift;
  my $class    = ref ($invocant) || $invocant;
  my $self     = {};

  bless $self, $class;
  $self->$_init(@_);

  return $self;

}
#
#===============================================================================



#-------------------------------------------------------------------------------
#
sub is_valid_number #($)#
{
  my $self   = shift;
  my $number = $self->normalize_number($_[0]);
  return unless defined $number;
  my $pattern = eval '$'.ref($self).'::NUMBER_PATTERN';
  return $number =~ /$pattern/;
}
#
#-------------------------------------------------------------------------------
#
sub normalize_number #($)#
{
  my $self   = shift;
  my $number = $_[0];
  return unless defined $number;
  $number =~ s/\D//g;
  return $number;
}
#
#-------------------------------------------------------------------------------
#
sub send #($$$)#
{

  my $self    = shift;
  my $to      = $_[0];
  my $from    = $_[1];
  my $message = $_[2];

  croak 'Missing to address for send'    unless defined $to;
  croak 'Missisng from address for send' unless defined $from;
  croak 'Missing message for send'       unless defined $message;
  croak 'Invalid from address for send'  unless Email::Valid->address( $from );
  croak 'Invalid to address for send'    unless $self->is_valid_number($to);

  my $pattern = eval '$'.ref($self).'::EMAIL_PATTERN';
  my $email   = sprintf $pattern, $to;

  open  MAIL, '|/usr/sbin/sendmail -t' or croak "Cannont access sendmail: $!";
  print MAIL "To: $email\n";
  print MAIL "From: $from\n";
  print MAIL "Subject: \n\n";
  print MAIL $message;
  close MAIL;

  return $SUCCESS;

}
#
#-------------------------------------------------------------------------------

1;

__END__

=head1 NAME

SMS::Carrier - Perl extension for describing SMS/MMS carriers

=head1 SYNOPSIS

  use SMS::Carrier;

=head1 DESCRIPTION

=head2 EXPORT

None by default

=head1 SEE ALSO

=head1 AUTHOR

Trev Harmon, E<lt>trevharmon@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Trev Harmon

THis library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.1 or,
at your option, any later version of Perl 5 you may have availablel
