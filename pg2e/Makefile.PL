#!/usr/bin/perl
# simple configure script for aegis, readapted for pg2e
# $Id: Makefile.PL,v 1.5 2005/02/13 15:27:58 ragnarok Exp $
use strict;
use Getopt::Long;

my ($help, $prefix, $perl_ver);
GetOptions('help' => \$help, 'prefix=s' => \$prefix);

if (defined($help)) {
	print <<"END";
Usage: configure [options]
Options:
  --help                  print this message
  --prefix=DIR            installation destination (will use
                          `pkg-config gtk+-2.0 --variable=prefix` by default)
END
} else {
	if (!defined($prefix)) {
		chomp($prefix = `pkg-config gtk+-2.0 --variable=prefix`);
	}
	$perl_ver = `perl -v|head -n 2|tail -n 1|sed "s|[^<]*v||"|sed "s|\ [^<]*||"`;
	printf("Configuration options:\n    prefix: %s\nWriting Makefile...\n", $prefix);
	open(SRC, 'Makefile.in');
	open(DST, '>Makefile');
	while (<SRC>) {
		s/\@PREFIX\@/$prefix/g;
		s/\@PERL_VER\@/$perl_ver/g;
		print DST $_;
	}
	close(SRC);
	close(DST);
	print "Now type 'make' to build.\n";
}
