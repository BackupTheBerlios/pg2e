#!/usr/bin/perl -w
################################################################################
#									       #
# This file is part of Foobar.						       #
# 									       #
# Foobar is free software; you can redistribute it and/or modify               #
# it under the terms of the GNU General Public License as published by         #
# the Free Software Foundation; either version 2 of the License, or            #
# (at your option) any later version.					       #
# 									       #
# Foobar is distributed in the hope that it will be useful,                    #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		       #
# GNU General Public License for more details.				       #
# You should have received a copy of the GNU General Public License	       #
# along with Foobar; if not, write to the Free Software			       #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA    #
#       						                       #
################################################################################

use strict;
use Gtk2 '-init';
use Glib qw(FALSE TRUE);
use Manage qw(save_f read_f);

# In the best programming style, we define all global variables here.

my $accel;
my $buff;
my $menubar;
my $menu;
my $menu_1;
my $menu_file;
my $menu_new;
my $menu_open;
my $menu_save;
my $menu_quit;
my $menu_about;
my $menu_help;
my $scrolled;
my $vbox;
my $view;
my $window;

# Now we create the window, and connect it all signals we need
$window = Gtk2::Window->new('toplevel');
$window->signal_connect(delete_event => \&quitting);
$window->signal_connect(destroy => \&quitting);
$window->set_default_size(400, 400);
$window->set_position('center');
$window->set_title("PG2E - Perl Gtk2 Editor");

# Now let's create the TextView
$view = Gtk2::TextView->new();

# Now TextView is ready, but empty, we need input from user or from a file to
# fill out it. So all we have to do is to wait.

# Since we'll need to scroll, let's create a ScrolledWindow
$scrolled = Gtk2::ScrolledWindow->new(undef, undef);
$scrolled->add_with_viewport($view);

# Let's create the menu.
$accel = Gtk2::AccelGroup->new();
# First: Menubar
$menubar = Gtk2::MenuBar->new();
# Second: Menu
$menu = Gtk2::Menu->new();

# Third (and fourth, fiveth, sixth, seventh, eighth, nineth....): menuitems
$menu_new = Gtk2::ImageMenuItem->new_from_stock("gtk-new", $accel);
$menu_new->signal_connect("activate", \&new);
$menu->append($menu_new);

$menu_open = Gtk2::ImageMenuItem->new_from_stock("gtk-open", $accel);
$menu_open->signal_connect("activate", \&read_buff);
$menu->append($menu_open);

$menu_save = Gtk2::ImageMenuItem->new_from_stock("gtk-save-as", $accel);
$menu_save->signal_connect("activate", \&save_buff);
$menu->append($menu_save);

$menu_quit = Gtk2::ImageMenuItem->new_from_stock("gtk-quit", $accel);
$menu_quit->signal_connect("activate", \&quitting);
$menu->append($menu_quit);

# Almost end: A menuitem will be the "menu" as the user will see
$menu_file = Gtk2::MenuItem->new_with_mnemonic("_File");
$menu_file->set_submenu($menu);

$menubar->append($menu_file);

$menu_1 = Gtk2::Menu->new();
$accel->connect('97', ['control-mask'], ['visible'], \&credits);
$menu_about = Gtk2::MenuItem->new_with_mnemonic("_About     Ctrl+A");
$menu_about->signal_connect("activate", \&about);
$menu_1->append($menu_about);

$menu_help = Gtk2::MenuItem->new_with_mnemonic("_Help");
$menu_help->set_submenu($menu_1);

$menubar->append($menu_help);

#Now regroup all in a VerticalBox
$vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->pack_start($menubar, FALSE, FALSE, 0);
$vbox->pack_start($scrolled, TRUE, TRUE, 0);

# Now add the VBox to the Window...
$window->add($vbox);
$window->add_accel_group($accel);

# ...and show everything ever created in this Program.
$window->show_all();

# Start lopping
Gtk2->main();
# The program would never reach this point, but we give a false instruction just
# in case
0;

# Subroutines section:

# This is called if someone wants to now s.th. about the program
sub about {
	
	my $dialog = Gtk2::Dialog->new("About", $window, [qw/modal destroy-with-parent/], 'gtk-close' => 'close', 'credits' => 'yes');
	my $label = Gtk2::Label->new("PG2E - Perl Gtk2 Editor\nVersion 0.1rc1");
	$dialog->vbox->add($label);
	$label->show();
	if($dialog->run eq 'yes') {
		credits($dialog);
	}
	$dialog->destroy();
}

sub credits {
	
	my $dial = Gtk2::Dialog->new("Credits", $_, [qw/modal destroy-with-parent/], 'close' => 'close');
	my $local_buff = Gtk2::TextBuffer->new();
	$local_buff->set_text('Stefano Esposito <yankeegohome@crux-it.org>');
	my $local_view = Gtk2::TextView->new_with_buffer($local_buff);
	$dial->vbox->add($local_view);
	$local_view->show();
	$dial->run;
	$dial->destroy;
}
# This create a new buffer, called when s.o. clieck on "New" in the File menu
sub new {
	
	my $local_buff = $view->get_buffer();
	my $start_iter = $local_buff->get_start_iter;
	my $end_iter = $local_buff->get_end_iter;
	
	my $bool;
	
	if ($local_buff->get_char_count() != 0) {
		my $dialog = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'ok', "The buffer isn't empty, going on to create a new buffer will destroy the present buffer. you want to go on?");
		$dialog->add_button("Cancel", 'cancel');
		if('cancel' eq $dialog->run) {
			$bool = 0;
		}
		else {
			$bool = 1;
		}
		$dialog->destroy();
	}
	if ($bool) {
		$local_buff->delete($start_iter, $end_iter);
		$view->set_buffer($local_buff);
	}
	else {
		return;
	}
}

# Saves the buffer to a file
sub save_buff {
	
	my $local_buff = $view->get_buffer;
	
	my $txt;
	my $name;
	
	my $start_iter = $local_buff->get_start_iter;
        my $end_iter = $local_buff->get_end_iter;
	
	if ($local_buff->get_char_count() == 0) {
		my $diag = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'error', 'ok', 'The buffer is empty. Nothing to save');
		$diag->run;
		$diag->destroy;
		return 0;
	}
	my $f_chsr = Gtk2::FileChooserDialog->new("Save", $window, "save", 'gtk-save', 'accept', 'gtk-cancel', 'cancel');
	if ($f_chsr->run eq 'accept') {
		$name = $f_chsr->get_filename;
		$txt = $local_buff->get_text($start_iter, $end_iter, TRUE);
		local $/ = "";
		if(!chomp($txt)) {
			$txt = "$txt\n"
		}
		my $ver = save_f($name, $txt); # Defined in Manage.pm
		$f_chsr->destroy();
		if (!$ver) {
			my $err = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no',  "File $name alredy existing.\nOverwrite?");
			if($err->run ne 'no') {
				save_f($name, $txt, TRUE);
			}
			$err->destroy();
		}
		$buff = $view->get_buffer;
	}
	else {
		$f_chsr->destroy();
	}
	return;
}

# Reads a buffer from a file and set it to the TextView
sub read_buff {
	
	my $local_buff = $view->get_buffer;
	my $go_on = 1;
	my $f_name;
	my $txt;
	
	if ($local_buff->get_char_count != 0) {
		my $diag = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'ok', "The buffer isn't empty. Reading from file will destroy this buffer.\nYou want to read from a file?");
		$diag->add_button('cancel', 'no');
		if ($diag->run eq 'no') {
			$go_on = 0;
		}
		else {
			$go_on = 1;
		}
		$diag->destroy;
	}
	if ($go_on) {
		my $f_chsr = Gtk2::FileChooserDialog->new("Open", $window, 'open', 'gtk-open', 'accept', 'gtk-cancel', 'cancel');
		if ($f_chsr->run eq 'accept') {
			$f_name = $f_chsr->get_filename;
			$txt = read_f($f_name);
			$local_buff = Gtk2::TextBuffer->new();
			$local_buff->insert($local_buff->get_start_iter, $txt);
			$view->set_buffer($local_buff);
			$f_chsr->destroy;
		}
		else {
			$f_chsr->destroy;
			return;
		}
	}
	else {
		return;
	}
	return;
}

sub quitting {
	
	my $local_buff = $view->get_buffer;
	if($buff) {
		if ($buff eq $local_buff) {
			Gtk2->main_quit;
			exit 0;
		}
		else {
			my $dial = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no', 'It seems that you modified the buffer since last change\NYou want to save changes?');
			if($dial->run eq 'yes') {
				save_buff;
				$dial->destroy;
			}
			else {
				Gtk2->main_quit;
			}
		}
	}
	else {
		Gtk2->main_quit;
	}
}
