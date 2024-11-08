SHELL:=/bin/bash

DESTDIR=

BINDIR=/usr/sbin
MANDIR=/usr/share/man/man1
SHAREDIR=/usr/share/klask
LIBDIR=/usr/lib/klask
CRONDIR=/etc/cron.d
ETCDIR=/etc/klask
COMPDIR=/etc/bash_completion.d

.PHONY: all install update sync upload stat help pkg pages

all:
	pod2man klask | gzip > klask.1.gz
	pod2html --css podstyle.css --index --header klask > klask.html

install: update
	@install -d -m 0755 -o root -g root $(DESTDIR)/$(CRONDIR)
	install    -m 0644 -o root -g root klask.cron $(DESTDIR)/$(CRONDIR)/klask

update:
	@install -d -m 0755 -o root -g root $(DESTDIR)/$(BINDIR)
	install    -m 0755 -o root -g root klask $(DESTDIR)/$(BINDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(LIBDIR)
	install    -m 0755 -o root -g root push-web      $(DESTDIR)/$(LIBDIR)
	install    -m 0755 -o root -g root klask-wrapper $(DESTDIR)/$(LIBDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(MANDIR)
	install    -m 0644 -o root -g root klask.1.gz $(DESTDIR)/$(MANDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(SHAREDIR)
	install    -m 0644 -o root -g root sorttable-klask.js $(DESTDIR)/$(SHAREDIR)
	install    -m 0644 -o root -g root style-klask.css    $(DESTDIR)/$(SHAREDIR)
	install    -m 0644 -o root -g root ui.js              $(DESTDIR)/$(SHAREDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(ETCDIR)
	install    -m 0644 -o root -g root klask-sample.conf    $(DESTDIR)/$(ETCDIR)
	install    -m 0644 -o root -g root push-web-sample.conf $(DESTDIR)/$(ETCDIR)

	@install -d -m 0755 -o root -g root $(DESTDIR)/$(COMPDIR)
	install    -m 0644 -o root -g root klask.bash_completion $(DESTDIR)/$(COMPDIR)/klask

sync:
	svn update

upload:
	cadaver --rcfile=cadaverrc

pkg: all
	./make-package-debian

pages: all pkg
	mkdir -p public/download
	cp -p *.html       public/
	cp -p podstyle.css public/
	cp -p LICENSE.txt  public/
	cp -p --no-clobber klask_*_all.deb  public/download/
	cd public; ln -sf klask.html index.html
	echo '<html><body><h1>Klask Debian Package</h1><ul>' > public/download/index.html
	(cd public/download; while read file; do printf '<li><a href="%s">%s</a> (%s)</li>\n' $$file $$file $$(stat -c %y $$file | cut -f 1 -d ' '); done < <(ls -1t *.deb) >> index.html)
	echo '</ul></body></html>' >> public/download/index.html

stat:
	svn log|egrep '^r[[:digit:]]'|egrep -v '^r1[[:space:]]'|awk '{print $$3}'|sort|uniq -c                 |gnuplot -p -e 'set style fill solid 1.00 border 0; set style histogram; set style data histogram; set xtics rotate by 0; set style line 7 linetype 0 linecolor rgb "#222222"; set grid ytics linestyle 7; set xlabel "User contributor" font "bold"; set ylabel "Number of commit" font "bold"; plot "/dev/stdin" using 1:xticlabels(2) title "commit" linecolor rgb "#666666"'
	(echo '0 2015'; svn log|egrep '^r[[:digit:]]'|awk '{print $$5}'|cut -f 1 -d '-'|sort|uniq -c)|sort -k 2|gnuplot -p -e 'set style fill solid 1.00 border 0; set style histogram; set style data histogram; set xtics rotate by 0; set style line 7 linetype 0 linecolor rgb "#222222"; set grid ytics linestyle 7; set xlabel "Year"             font "bold"; set ylabel "Number of commit" font "bold"; plot "/dev/stdin" using 1:xticlabels(2) title "commit" linecolor rgb "#666666"'

help:
	@echo "Possibles targets:"
	@echo " * all     : make manual"
	@echo " * install : complete install"
	@echo " * update  : update install (do not update cron file)"
	@echo " * sync    : sync with official repository"
	@echo " * upload  : upload on public dav forge space"
	@echo " * pkg     : build Debian package"
	@echo " * pages   : build pages for GitLab-CI"
	@echo " * stat    : svn stat with gnuplot graph"
