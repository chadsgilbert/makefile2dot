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
TARGZ = dist/makefile2dot-$(VERSION).tar.gz
TEMP = \
	$(TARGZ) \
	.linted \
	.checked \
	.built \
	.uploaded \
	example.dot \
	example.png

.PHONY: install
install:
	conda env create -f environment.yml && \
	conda activate makefile2dot

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
build: .built
.built: .checked
	conda build .

.PHONY: upload
upload: .uploaded

.uploaded: .built
	anaconda login --username $(CONDA_USER) --password $(CONDA_PASS) && \
	anaconda upload $(WHEEL) $(TARGZ) && touch .uploaded

.PHONY: clean
clean:
	rm -f $(TEMP)
