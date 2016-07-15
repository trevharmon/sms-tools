use Test::More tests => 11;
BEGIN { use_ok('SMS::Carrier::US::TMobile') };

#########################

my $carrier = new SMS::Carrier::US::TMobile;
is(ref $carrier, 'SMS::Carrier::US::TMobile', 'Inherited Class');
ok($carrier->isa('SMS::Carrier'), 'Base Class');

my @phone_numbers_good = (
                           '202-456-1111',
                           '(202) 456-1111',
                           '2024561111'
                          );
my @phone_numbers_bad  = (
                           '456-1111',
                           '(202) 4US-PRES',
                           '1-202-456-1111',
                           '12024561111',
                           '+1 202 456 1111'
                         );

foreach my $number (@phone_numbers_good)
{
  ok($carrier->is_valid_number($number), qq|Valid number: "$number"|);
}

foreach my $number (@phone_numbers_bad)
{
  ok(!$carrier->is_valid_number($number), qq|Invalid number: "$number"|);
}
