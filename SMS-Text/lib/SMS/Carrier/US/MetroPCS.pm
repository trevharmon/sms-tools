package SMS::Carrier::US::MetroPCS;
our $VERSION = 0.01;
our @ISA = qw( SMS::Carrier );

require 5.8.0;
use strict;
use warnings;
use Carp;
use Readonly;
use SMS::Carrier;

################################################################################
#
Readonly our $EMAIL_PATTERN  => '%s@mymetropcs.com';
Readonly our $NUMBER_PATTERN => qr/^\d{10}$/;
#
################################################################################



#===============================================================================
#
#my $_init = sub
#{
#};
#
#===============================================================================



#-------------------------------------------------------------------------------
#
#sub is_valid_number #($)#
#{
#}
#
#-------------------------------------------------------------------------------
#
#sub normalize_number #($)#
#{
#}
#
#-------------------------------------------------------------------------------
#
#sub send #($$$)#
#{
#}
#
#-------------------------------------------------------------------------------

1;

__END__
