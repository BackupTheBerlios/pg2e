#!/usr/bin/perl -w
################################################################################
#									       #
# This file is part of Pg2e.						       #
# 									       #
# Pg2e is free software; you can redistribute it and/or modify                 #
# it under the terms of the GNU General Public License as published by         #
# the Free Software Foundation; either version 2 of the License, or            #
# (at your option) any later version.					       #
# 									       #
# Pg2e is distributed in the hope that it will be useful,                      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		       #
# GNU General Public License for more details.				       #
# You should have received a copy of the GNU General Public License	       #
# along with Pg2e; if not, write to the Free Software			       #
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
my $global_txt;
my $curr_name;
my $menubar;
my $menu_0;
my $menu_1;
my $menu_2;
my $menu_about;
my $menu_file;
my $menu_help;
my $menu_new;
my $menu_open;
my $menu_quit;
my $menu_save;
my $menu_save_as;
my $menu_toolbar;
my $menu_view;
my $saved;
my $scrolled;
my $toolbar;
my $vbox;
my $view;
my $window;

# Now we create the window, and connect it all signals we need
$window = Gtk2::Window->new('toplevel');
$window->signal_connect(delete_event => \&quitting);
$window->signal_connect(destroy => \&quitting);
$window->set_default_size(800, 400);
$window->set_position('center');


# Now let's create the TextView
$view = Gtk2::TextView->new();
$view->set_right_margin(10);

if($ARGV[0]) {
	my $buffer = Gtk2::TextBuffer->new();
	my $txt = read_f($ARGV[0]);
	$buffer->set_text($txt);
	$view->set_buffer($buffer);
	$saved = 1;
	$global_txt = $txt;
	$window->set_title("PG2E - Perl Gtk2 Editor - $ARGV[0]");
	$curr_name = $ARGV[0];
}
else {
	$window->set_title("PG2E - Perl Gtk2 Editor - New Buffer");
}
# Now TextView is ready, but empty, we need input from user or from a file to
# fill out it. So all we have to do is to wait.

# Since we'll need to scroll, let's create a ScrolledWindow
$scrolled = Gtk2::ScrolledWindow->new(undef, undef);
$scrolled->set_policy('automatic', 'automatic');
$scrolled->add_with_viewport($view);

# Let's create the menu.
$accel = Gtk2::AccelGroup->new();
# First: Menubar
$menubar = Gtk2::MenuBar->new();
# Second: Menu
$menu_0 = Gtk2::Menu->new();

# Third (and fourth, fiveth, sixth, seventh, eighth, nineth....): menuitems
$menu_new = Gtk2::ImageMenuItem->new_from_stock("gtk-new", $accel);
$menu_new->signal_connect("activate", \&new);
$menu_0->append($menu_new);

$menu_open = Gtk2::ImageMenuItem->new_from_stock("gtk-open", $accel);
$menu_open->signal_connect("activate", \&read_buff);
$menu_0->append($menu_open);

$menu_save = Gtk2::ImageMenuItem->new_from_stock('gtk-save', $accel);
$menu_save->signal_connect("activate", \&save_with_name);
$menu_0->append($menu_save);

$menu_save_as = Gtk2::ImageMenuItem->new_from_stock("gtk-save-as", $accel);
$menu_save_as->signal_connect("activate", \&save_buff);
$menu_0->append($menu_save_as);

$menu_quit = Gtk2::ImageMenuItem->new_from_stock("gtk-quit", $accel);
$menu_quit->signal_connect("activate", \&quitting);
$menu_0->append($menu_quit);

# Almost end: A menuitem will be the "menu" as the user will see
$menu_file = Gtk2::MenuItem->new_with_mnemonic("_File");
$menu_file->set_submenu($menu_0);

$menubar->append($menu_file);

$menu_1 = Gtk2::Menu->new();
$menu_toolbar = Gtk2::CheckMenuItem->new_with_mnemonic('_Toolbar');
$menu_toolbar->set_active(TRUE);
$menu_toolbar->signal_connect('toggled', \&toggle_toolbar);
$menu_1->append($menu_toolbar);

$menu_view = Gtk2::MenuItem->new_with_mnemonic("_View");
$menu_view->set_submenu($menu_1);

$menubar->append($menu_view);

$menu_2 = Gtk2::Menu->new();
$accel->connect('97', ['control-mask'], ['visible'], \&credits);
$menu_about = Gtk2::MenuItem->new_with_mnemonic("_About     Ctrl+A");
$menu_about->signal_connect("activate", \&about);
$menu_2->append($menu_about);

$menu_help = Gtk2::MenuItem->new_with_mnemonic("_Help");
$menu_help->set_submenu($menu_2);

$menubar->append($menu_help);


# After menu it's toolbar time
$toolbar = Gtk2::Toolbar->new();
$toolbar->set_style('icons');
$toolbar->insert_stock('gtk-new', 'New', undef, \&new, undef, -1);
$toolbar->insert_stock('gtk-open', 'Open', undef, \&read_buff, undef, -1);
$toolbar->insert_stock('gtk-save-as', 'Save As', undef, \&save_buff, undef, -1);
$toolbar->insert_stock('gtk-save', 'Save', undef, \&save_with_name, undef, -1);
$toolbar->insert_space(10);
$toolbar->insert_stock('gtk-copy', 'Copy to clipboard', undef, \&copy, undef, -1);
$toolbar->insert_stock('gtk-paste', 'Paste', undef, \&paste, undef, -1);
$toolbar->insert_stock('gtk-cut', 'Cut', undef, \&cut, undef, -1);
$toolbar->insert_space(10);
$toolbar->insert_stock('gtk-justify-left', 'Left Align', undef, \&justify, 'left', -1);
$toolbar->insert_stock('gtk-justify-center', 'Center', undef, \&justify, 'center', -1);
$toolbar->insert_stock('gtk-justify-right', 'Right Align', undef, \&justify, 'right', -1);

# Now regroup all in a VerticalBox
$vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->pack_start($menubar, FALSE, FALSE, 0);
$vbox->pack_start($toolbar, FALSE, FALSE, 0);
$vbox->pack_start($scrolled, TRUE, TRUE, 0);

# Now add the VBox to the Window...
$window->add($vbox);
$window->add_accel_group($accel);

# ...and show everything ever created in this Program.
$window->show_all();

# Start lopping
Gtk2->main();
# The program should never reach this point, but we give an exit with no errors just in case

exit 0;

# Subroutines section:

# This is called if someone wants to now s.th. about the program
sub about {
	# Ceates a new dialog, add it a label and two buttons: close and credits.
	# If clicked, credits calls sub credits, whit dialog as argument.
	my $dialog = Gtk2::Dialog->new("About", $window, [qw/modal destroy-with-parent/], 'gtk-close' => 'close', 'credits' => 'yes');
	my $label = Gtk2::Label->new("PG2E - Perl Gtk2 Editor\nVersion 0.1rc2");
	$dialog->vbox->add($label);
	$label->show();
	if($dialog->run eq 'yes') {
		credits($dialog);
	}
	$dialog->destroy();
}

# Called when someone clicks on credits button in about dialog.
sub credits {
	
	my $dial = Gtk2::Dialog->new("Credits", $_, [qw/modal destroy-with-parent/], 'close' => 'close');
	my $local_buff = Gtk2::TextBuffer->new();
	$local_buff->set_text('Stefano Esposito <yankeegohome@crux-it.org>');
	my $local_view = Gtk2::TextView->new_with_buffer($local_buff);
	$local_view->set_editable(FALSE);
	$local_view->set_cursor_visible(FALSE);
	$dial->vbox->add($local_view);
	$local_view->show();
	$dial->run;
	$dial->destroy;
}
# This creates a new buffer, called when s.o. click on "New" in the File menu
sub new {
	
	my $local_buff = $view->get_buffer();
	my $start_iter = $local_buff->get_start_iter;
	my $end_iter = $local_buff->get_end_iter;
	
	my $bool;
	# If the current buffer isn't empty shows a question. 
	if ($local_buff->get_char_count() != 0) {
		my $dialog = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no', "The buffer isn't empty, going on to create a new buffer will destroy the present buffer. you want to go on?");
		if('no' eq $dialog->run) {
			$bool = 0;
		}
		else {
			$bool = 1;
		}
		$dialog->destroy();
	}
	if ($bool) {# if previous question was answered yes
		$local_buff->delete($start_iter, $end_iter);
		$view->set_buffer($local_buff);
	}
	else {
		return;
	}
	$window->set_title("PG2E - Perl Gtk2 Editor - New Buffer");
	$ARGV[0] = undef;
	$curr_name = undef;
	$saved = 0;# We know that the current buffer hasn't been saved.
	return;
}

# Saves the buffer to a file
sub save_buff {
	
	my $local_buff = $view->get_buffer;
	
	my $f_name;
	my $txt;
	
	my $start_iter = $local_buff->get_start_iter;
        my $end_iter = $local_buff->get_end_iter;
	# If the buffer is empty we have nothing to save.
	if ($local_buff->get_char_count() == 0) {
		my $diag = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'error', 'ok', 'The buffer is empty. Nothing to save');
		$diag->run;
		$diag->destroy;
		return 0;
	}
	my $f_chsr = Gtk2::FileChooserDialog->new("Save", $window, "save", 'gtk-save', 'accept', 'gtk-cancel', 'cancel');
	if ($f_chsr->run eq 'accept') {
		$f_name = $f_chsr->get_filename;
		$txt = $local_buff->get_text($start_iter, $end_iter, TRUE);
		$global_txt = $txt;
		local $/ = "";
		if(!chomp($txt)) {
			$txt = "$txt\n"
		}
		my $ver = save_f($f_name, $txt, FALSE); # Defined in Manage.pm
		$f_chsr->destroy();
		if (!$ver) {
			my $err = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no',  "File $f_name alredy existing.\nOverwrite?");
			if($err->run ne 'no') {
				save_f($f_name, $txt, TRUE);
			}
			$err->destroy();
		}
	}
	else {
		$f_chsr->destroy();
	}
	if(!$ARGV[0]) {
		$window->set_title("PG2E - Perl Gtk2 Editor - $f_name");
	}
	$curr_name = $f_name;
	$saved = 1;# Now we know that current buffer has been saved.
	return;
}

sub save_with_name {
	
	if(!$curr_name) {
		save_buff;
	}
	else {
		my $local_buff = $view->get_buffer;
		my $txt = $local_buff->get_text($local_buff->get_start_iter, $local_buff->get_end_iter, FALSE);
		save_f($curr_name, $txt, TRUE);
		$saved = 1;
		$global_txt = $txt;
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
		my $diag = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no', "The buffer isn't empty. Reading from file will destroy this buffer.\nYou want to read from a file?");
		if ($diag->run eq 'yes') {
			$go_on = 1;
		}
		else {
			$go_on = 0;
		}
		$diag->destroy;
	}
	if ($go_on) {
		my $f_chsr = Gtk2::FileChooserDialog->new("Open", $window, 'open', 'gtk-open', 'accept', 'gtk-cancel', 'cancel');
		if ($f_chsr->run eq 'accept') {
			$f_name = $f_chsr->get_filename;
			$txt = read_f($f_name);
			$local_buff = Gtk2::TextBuffer->new();
			$local_buff->set_text($txt);
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
	$window->set_title("PG2E - Perl Gtk2 Editor - $f_name");
	$curr_name = $f_name;
	$saved = 0;
	return;
}

# Called on quit, to preserve unsaved data and to quit from Gtk2->main;
sub quitting {

       my $local_buff = $view->get_buffer;
       my $local_txt = $local_buff->get_text($local_buff->get_start_iter, $local_buff->get_end_iter, FALSE);
       if ($saved) {
	       if($global_txt eq $local_txt) {
		       Gtk2->main_quit;
		       exit 0;
	       }
	       else {
		       my $dial = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no', "It seems that are unsaved changes\nYou'd like to save it?");
		       if($dial->run eq 'yes') {
			       save_buff;
			       Gtk2->main_quit;
			       exit 0;
		       }
		       else {
			       Gtk2->main_quit;
			       exit 0;
		       }
	       }
       }
       elsif($local_buff->get_char_count != 0) {
	       my $dial = Gtk2::MessageDialog->new($window, [qw/modal destroy-with-parent/], 'question', 'yes_no', "Do you want to save current buffer?");
	       if($dial->run eq 'yes') {
		       save_buff;
		       Gtk2->main_quit;
		       exit 0;
	       }
	       else {
		       Gtk2->main_quit;
		       exit 0;
	       }
       }
       else {
	       Gtk2->main_quit;
	       exit 0;
       }
}

# Copy/Paste/Cut subroutines, called whe user clicks on the toolbar buttons
sub copy {
	
	my $local_buff = $view->get_buffer;
	my $screen = $window->get_screen;
	my $display = $screen->get_display;
	my $atom = Gtk2::Gdk::Atom->intern("SELECTION", FALSE);
	my $clip = Gtk2::Clipboard->get_for_display($display, $atom);
	$local_buff->copy_clipboard($clip);
}

sub paste {

	my $local_buff = $view->get_buffer;
	my $display = Gtk2::Gdk::Display->get_default;
	my $atom = Gtk2::Gdk::Atom->intern("CLIPBOARD", FALSE);
	my $clip = Gtk2::Clipboard->get_for_display($display, $atom);
	$local_buff->paste_clipboard($clip, undef, TRUE);
}

sub cut {

	my $local_buff = $view->get_buffer;
	my $display = Gtk2::Gdk::Display->get_default;
	my $atom = Gtk2::Gdk::Atom->intern("PRIMARY", FALSE);
	my $clip = Gtk2::Clipboard->get_for_display($display, $atom);
	$local_buff->cut_clipboard($clip, TRUE);
}

# Text justify subroutines
sub justify {
	
	if($_[1] eq 'right') {
		
	$view->set_justification('right');
	}
	elsif($_[1] eq 'left') {
		$view->set_justification('left');
	}
	elsif($_[1] eq 'center') {
		$view->set_justification('center');
	}
	else {
		return;
	}
	return;
}

sub toggle_toolbar {

	if(!$menu_toolbar->get_active()) {
		$toolbar->hide_all;
	}
	else {
		$toolbar->show_all;
	}
}
