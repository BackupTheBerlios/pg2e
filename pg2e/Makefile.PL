use 5.008;
use ExtUtils::MakeMaker;

`mv lib/main.pl pg2e`;

WriteMakefile(
	'NAME' => 'PG2E',
	'VERSION' => '1.0rc3',
	'EXE_FILES' => [ 'pg2e' ],
	'PREREQ_PM' => { 'Gtk2' => '1.040' },
	'AUTHOR' => 'Stefano Esposito <ragnarok@email.it>',
	'clean' => { FILES => 'pg2e' },
);
