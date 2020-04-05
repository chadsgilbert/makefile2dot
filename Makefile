#
# Use this Makefile as an example.
#
# It also builds the project for disctibution. This way, you can visualize how
# the project is built and distributed.
#

default:
	@echo 'This is just a dummy (but working) Makefile.'
	@echo 'It could be used as an input file for the makefile2dot visualizer'
	@echo 'Type "make all" to generate example output.png' 

VERSION := 0.1.0

.PHONY: all
all: output.png

output.png: output.dot
	dot -Tpng < $< > $@

output.dot: Makefile makefile2dot/makefile2dot.py .linted .checked
	makefile2dot/makefile2dot.py < $< >$@

# Becomes invalidated if lint has to be re-run.
.linted: makefile2dot/makefile2dot.py
	pycodestyle makefile2dot.py && touch .linted

# Becomes invalidated if tests have to be re-run.
.checked: makefile2dot/makefile2dot.py
	pytest makefile2dot/makefile2dot.py && touch .checked

.PHONY: dist
dist: dist/makefile2dot-$(VERSION)-py3-none-any.whl

dist/makefile2dot-$(VERSION)-py3-none-any.whl: makefile2dot/__init__.py
	python -m setup bdist_wheel

.twine_checked: dist/makefile2dot-$(VERSION)-py3-none-any.whl
	twine check dist/makefile2dot-$(VERSION)-py3-none-any.whl && touch .twine_checked

clean:
	rm -f $(ALL)
