DESTDIR=

BINDIR=/usr/sbin
MANDIR=/usr/share/man/man1
SHAREDIR=/usr/share/klask
LIBDIR=/usr/lib/klask
CRONDIR=/etc/cron.d
ETCDIR=/etc/klask
COMPDIR=/etc/bash_completion.d

.PHONY: all install update sync upload help

all:
	pod2man klask | gzip > klask.1.gz
	pod2html klask > klask.html

install: update
	@install -d -m 0755 -o root -g root $(DESTDIR)/$(CRONDIR)
	install    -m 0644 -o root -g root klask.cron $(DESTDIR)/$(CRONDIR)/klask

update:
	@install -d -m 0755 -o root -g root $(DESTDIR)/$(BINDIR)
	install    -m 0755 -o root -g root klask $(DESTDIR)/$(BINDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(LIBDIR)
	install    -m 0755 -o root -g root push-web $(DESTDIR)/$(LIBDIR)
	install    -m 0755 -o root -g root klask-wrapper $(DESTDIR)/$(LIBDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(MANDIR)
	install    -m 0644 -o root -g root klask.1.gz $(DESTDIR)/$(MANDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(SHAREDIR)
	install    -m 0644 -o root -g root sorttable-klask.js $(DESTDIR)/$(SHAREDIR)
	install    -m 0644 -o root -g root style-klask.css $(DESTDIR)/$(SHAREDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(ETCDIR)
	install    -m 0644 -o root -g root klask-sample.conf $(DESTDIR)/$(ETCDIR)
	install    -m 0644 -o root -g root push-web-sample.conf $(DESTDIR)/$(ETCDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(COMPDIR)
	install    -m 0644 -o root -g root klask.bash_completion $(DESTDIR)/$(COMPDIR)/klask

sync:
	svn update

upload:
	cadaver --rcfile=cadaverrc

help:
	@echo "Cibles possibles :"
	@echo " * all     : construction du man"
	@echo " * install : installation complète"
	@echo " * update  : installation minimale"
	@echo " * sync    : synchronisation avec le dépôt officiel"
	@echo " * upload  : upload on public dav forge space"
