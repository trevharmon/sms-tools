use 5.008001;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'SMS::Text',
    VERSION_FROM      => 'lib/SMS/Text.pm',
    PREREQ_PM         => {
                           'Carp'         => 1.0,
                           'Email::Valid' => 1.195,
                           'Readonly'     => 1.03, 
                         },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/SMS/Text.pm', # retrieve abstract from module
       AUTHOR         => 'Trev Harmon <trevharmon@gmail.com>') : ()),
);
