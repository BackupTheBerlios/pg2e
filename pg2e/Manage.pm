###############################################################################
#									       #
#   This file is part of Pg2e.						       #
#   									       #
#   Pg2e is free software; you can redistribute it and/or modify               #
#   it under the terms of the GNU General Public License as published by       #
#   the Free Software Foundation; either version 2 of the License, or          #
#   (at your option) any later version.                                        #
#                 							       #
#   Pg2e is distributed in the hope that it will be useful,		       #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of 	       #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	       #
#   GNU General Public License for more details.			       #
#   									       #
#   You should have received a copy of the GNU General Public License	       #
#   along with Pg2e; if not, write to the Free Software			       #
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  #
#   									       #
################################################################################

package Manage;

use Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(save_f read_f);

sub save_f {
	my ($name, $txt, $force) = @_;

	if($force) {
		open(D, ">$name");
	}
	elsif(-e $name) {
		return 0;
	}
	else {
		open(D, ">$name");
	}
	print D $txt;
	close(D);
	return 1;
}

sub read_f {

	my ($f_name) = $_[0];
	my $txt = "";
	open(R, "<$f_name");
	while(<R>) {
		if ($txt) {
			$txt = $txt.$_;
		}
		else {
			$txt = $_;
		}
	}
	close(D);
	return $txt;
}
