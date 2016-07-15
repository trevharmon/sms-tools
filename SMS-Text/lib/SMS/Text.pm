package SMS::Text;
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
Readonly my $CARRIER => 'carrier';
Readonly my $FROM    => 'from';
Readonly my $NUMBER  => 'number';
#
################################################################################
#
Readonly my $SUCCESS => 1;
Readonly my $FAILURE => 0;
#
################################################################################



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
sub inSMS
{
  return <<'END';
000A
000C	000D
0020	005F
0061	007E
0080	0085
008A
008E	0092
0094	0095
00A4	00A5
00A8
00AD
00E1	00E2
00E4
00E8	00EA
00F0
END
}
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
sub is_valid_sms_characters #($)#
{
  return $_[0] =~ /^\p{inSMS}+$/;
}
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#===============================================================================
#
my $_init = sub
{

  my $self = shift;
  my %data = @_;

  croak 'Missing carrier'       unless exists $data{ $CARRIER };
  croak 'Missing from email'    unless exists $data{ $FROM    };
  croak 'Missing mobile number' unless exists $data{ $NUMBER  };
  croak 'Invalid carrier'       unless ref(   $data{ $CARRIER })
                                       and    $data{ $CARRIER }->isa('SMS::Carrier');
  croak "Invalid from email: $Email::Valid::Details"
    unless Email::Valid->address( $data{$FROM} );

  $self->{ $CARRIER } = $data{ $CARRIER };
  $self->{ $FROM    } = $data{ $FROM    };

  croak 'Invalid number' unless $self->{$CARRIER}->is_valid_number($data{$NUMBER});
  $self->{ $NUMBER  } = $self->{$CARRIER}->normalize_number($data{$NUMBER});

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
sub get_carrier () { return $_[0]->{ $CARRIER } }
sub get_number  () { return $_[0]->{ $NUMBER  } }
#
#-------------------------------------------------------------------------------
#
sub send #($)#
{

  my $self    = shift;
  my $message = $_[0];

  carp 'Message contains invalid SMS characters'
    unless is_valid_sms_characters($message);

  return $self->{$CARRIER}->send($self->{$NUMBER}, $self->{$FROM}, $message);

}
#
#-------------------------------------------------------------------------------

1;

__END__

=head1 NAME

SMS::Text - Perl extension for sending SMS/MMS messages via email

=head1 SYNOPSIS

  use SMS::Text

=head1 DESCRIPTION

=head2 EXPORT

None by default


=head1 SEE ALSO

=head1 AUTHOR

Trev Harmon, E<lt>trevharmon@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Trev Harmon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.1 or,
at your option, any later version of Perl 5 you may have availble.
