#
# Use this Makefile as an example.
#
# It also builds the project for disctibution. This way, you can visualize how
# the project is built and distributed.
#

.PHONY: default
default:
	@echo 'Type "make install" to configure the environment (only needed once).'
	@echo 'Type "make all" to generate example output.png.'
	@echo 'Type "make dist" to generate the distributables.'
	@echo 'Type "make upload" to upload the distributables to pypi.'

# Variables for long names.
VERSION := 1.0.2
LIB_FILES := makefile2dot/__init__.py
TEST_FILES := makefile2dot/test_makefile2dot.py
WHEEL = dist/makefile2dot-$(VERSION)-py3-none-any.whl
TARGZ = dist/makefile2dot-$(VERSION).tar.gz
TEMP = $(WHEEL) \
	$(TARGZ) \
	.linted \
	.checked \
	.twine_checked \
	.uploaded \
	example.dot \
	example.png

.PHONY: install
install:
	conda env create -f environment.yml

.PHONY: all
all: output.png

output.png: output.dot
	dot -Tpng < $< > $@

output.dot: Makefile .checked # This is a comment
	scripts/makefile2dot --direction TB -o $@

.PHONY: lint
lint: .linted

.linted: $(LIB_FILES) scripts/makefile2dot
	pycodestyle $(LIB_FILES) scripts/makefile2dot && touch .linted

.PHONY: check
check: .checked

.checked: .linted $(TEST_FILES)
	pytest && touch .checked

.PHONY: dist
dist: .twine_checked

$(WHEEL): .checked setup.py
	python -m setup bdist_wheel

$(TARGZ): .checked setup.py
	python -m setup sdist

.twine_checked: $(WHEEL) $(TARGZ)
	twine check dist/* && touch .twine_checked

.PHONY: upload
upload: .uploaded

.uploaded: .twine_checked
	twine upload -u $(PYPI_USER) -p $(PYPI_PASS) $(WHEEL) $(TARGZ) && touch .uploaded

.PHONY: clean
clean:
	rm -f $(TEMP)
