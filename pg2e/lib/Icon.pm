###############################################################################
##                                                                              ##   This file is part of Pg2e.                                                 ##                                                                              ##   Pg2e is free software; you can redistribute it and/or modify               ##   it under the terms of the GNU General Public License as published by       ##   the Free Software Foundation; either version 2 of the License, or          ##   (at your option) any later version.                                        ##                                                                              ##   Pg2e is distributed in the hope that it will be useful,                    ##   but WITHOUT ANY WARRANTY; without even the implied warranty of             ##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              ##   GNU General Public License for more details.                               ##                                                                              ##   You should have received a copy of the GNU General Public License          ##   along with Pg2e; if not, write to the Free Software                        ##   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  ##                                                                              ################################################################################

package Icon;
use Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw(get_icon);

use strict;
use Gtk2 '-init';

sub get_icon {
	if (-e './mascotte.jpg') {
		my $icon = Gtk2::Gdk::Pixbuf->new_from_file('mascotte.jpg');
		return $icon;
	}
	else {
		return;
	}
}
