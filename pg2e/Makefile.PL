use Gtk2 '-init';

if ($Gtk2::VERSION => '1.040') {

	`cp Makefile.am Makefile`;
}
else {
	print "Gtk2-Perl 1.040 or higher needed";
}
