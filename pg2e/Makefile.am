PREFIX = /usr
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
PERL_VER = 5.8.6
PERL_DIR = $(LIBDIR)/perl5/site_perl/$(PERL_VER)

all : 
	cp main.pl pg2e

install :
	install -d -m 0755 $(DESTDIR)$(BINDIR)
	install -d -m 0755 $(DESTDIR)$(PERL_DIR)	
	install -m 0755 pg2e $(DESTDIR)$(BINDIR)
	install	-m 0644 Manage.pm $(DESTDIR)$(PERL_DIR)
