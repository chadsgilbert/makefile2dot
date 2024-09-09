SHELL = bash
MAKEVER = 3.81
TARBALL = https://ftpmirror.gnu.org/make/make-$(MAKEVER).tar.gz
MAKEFILE2DOT = $(realpath $(PWD)/../scripts/makefile2dot)
FORMAT = svg

test: prep
	@set -euo pipefail; \
	pushd graphs >/dev/null; \
	for makefile in ../makefiles/*.mk; do \
		echo -e "\n## $$makefile"; \
		ln -sf $$makefile Makefile; \
		$(MAKEFILE2DOT); \
		:| dot -T$(FORMAT) > $${makefile%.*}.$(FORMAT); \
	done

prep: make-$(MAKEVER)/doc/make.texi
	mkdir -p graphs

make-$(MAKEVER)/doc/make.texi: make-$(MAKEVER).tar.gz 
	tar xf $< $@

make-$(MAKEVER).tar.gz:
	(curl -sSL $(TARBALL) || wget -nv -O- $(TARBALL)) > $@

clean:
	-rm make-$(MAKEVER).tar.gz:
	-rm -r make-$(MAKEVER)/
	-rm -r makefiles/
	-rm -r graphs/
