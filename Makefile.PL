use 5.006;
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name     'Frugalicious';
all_from 'lib/Frugalicious.pm';
author   q{Brad Haywood <brad@perlpowered.com>};
license  'artistic2';

perl_version 5.006;

tests_recursive('t');

resources (
   #homepage   => 'http://yourwebsitehere.com',
   #IRC        => 'irc://irc.perl.org/#Frugalicious',
   license    => 'http://www.perlfoundation.org/artistic_license_2_0',
   #repository => 'git://github.com/Brad Haywood/Frugalicious.git',
   bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Frugalicious',
);

configure_requires (
   'Module::Install' => 0,
);

build_requires (
   'Test::More' => 0,
);

requires (
    'Kelp' => 0,
    'Moo'  => 0,
);

install_as_cpan;
auto_install;
WriteAll;
