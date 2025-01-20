SHELL = bash
MAKEVER = 3.81
TARBALL = https://ftpmirror.gnu.org/make/make-$(MAKEVER).tar.gz
MAKEFILE2DOT = $(realpath $(PWD)/../scripts/makefile2dot)
FORMAT = svg

test: prep
	@set -euo pipefail; \
	pushd graphs; \
	for makefile in ../makefiles/*.mk; do \
		echo "## working on $$makefile…" >&2; \
		ln -sf $$makefile Makefile; \
		basename=$$(basename $$makefile .mk); \
		$(MAKEFILE2DOT) 2>$$basename.err \
		  | dot -T$(FORMAT) 2>$$basename.dot.err \
		  > $$basename.$(FORMAT); \
	done

prep: makefiles
	mkdir -p graphs

.PHONY: makefiles
makefiles: make-$(MAKEVER)/doc/make.texi
	mkdir -p makefiles
	perl texi2makefiles.pl $^ $@

make-$(MAKEVER)/doc/make.texi: make-$(MAKEVER).tar.gz 
	tar xf $< $@

make-$(MAKEVER).tar.gz:
	(curl -sSL $(TARBALL) || wget -nv -O- $(TARBALL)) > $@

clean:
	-rm -r make-$(MAKEVER)/
	-rm -r makefiles/

distclean: clean
	-rm make-$(MAKEVER).tar.gz
	-rm -r graphs/
