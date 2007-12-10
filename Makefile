DESTDIR=
BINDIR=/usr/sbin
MANDIR=/usr/share/man/man1
CRONDIR=/etc/cron.d

all:
	pod2man klask | gzip > klask.1.gz

install:
	install -d -m 0755 -o root -g root $(DESTDIR)/$(BINDIR)
	install    -m 0755 -o root -g root klask $(DESTDIR)/$(BINDIR)

	install -d -m 0755 -o root -g root $(DESTDIR)/$(MANDIR)
	install    -m 0644 -o root -g root klask.1.gz $(DESTDIR)/$(MANDIR)

	install -d -m 0755 -o root -g root $(DESTDIR)/$(CRONDIR)
	install    -m 0644 -o root -g root klask.cron $(DESTDIR)/$(CRONDIR)/klask
