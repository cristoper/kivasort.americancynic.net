ROOTDIR := root
OUTPUTDIR := output
SRC_JSDIR := js
SRC_CSSDIR := css
DST_JSDIR = $(OUTPUTDIR)/$(SRC_JSDIR)
DST_CSSDIR = $(OUTPUTDIR)/$(SRC_CSSDIR)

ROOT_FILES = $(wildcard $(ROOTDIR)/*)
DST_ROOT_FILES = $(patsubst root/%, $(OUTPUTDIR)/%, $(ROOT_FILES))

UGLIFY := node_modules/uglify-js/bin/uglifyjs
UGLYFLAGS := --compress --mangle

PP := m4
PPFLAGS := $(if $(DEBUG_MODE), -DDEBUG_MODE)
# To enable use of pre-fetched partners.json use:
PPFLAGS += $(if $(NO_AJAX), -Dno_ajax)

all: $(OUTPUTDIR)/index.html $(DST_ROOT_FILES) $(DST_CSSDIR)/main.css $(DST_JSDIR)/partners.json

deploy-pages: all
	sh deploy-to-pages.sh

$(OUTPUTDIR)/index.html: index.html $(SRC_JSDIR)/combined.js
	$(PP) $(PPFLAGS) $< > $@

# Combine main.js, partners.json, kiva_sort.js
# If $(DEBUG_MODE) is defined, then don't compress (ie: make DEBUG_MODE=yes)
$(SRC_JSDIR)/combined.js: $(SRC_JSDIR)/main.js $(SRC_JSDIR)/ks/kiva_sort.js \
    | $(DST_JSDIR)
	$(PP) $(PPFLAGS) $< > $@
	$(if $(DEBUG_MODE),,$(UGLIFY) $@ $(UGLYFLAGS) -o $@)

$(SRC_JSDIR)/partners.json:
	$(SRC_JSDIR)/ks/fetchkivajson.js > $@

$(DST_JSDIR)/partners.json: $(SRC_JSDIR)/partners.json
	# Only copy to output/ if no_ajax is specified
	$(if $(NO_AJAX), cp $< $@)

$(DST_CSSDIR)/main.css: $(SRC_CSSDIR)/main.css | $(DST_CSSDIR)
	cp $< $@

$(OUTPUTDIR) $(DST_JSDIR) $(DST_CSSDIR):
	test -d $@ || mkdir $@

# Copy everything in root/ to output/
$(DST_ROOT_FILES): output/%: root/%|$(OUTPUTDIR)
	cp $< $(OUTPUTDIR)

clean:
	-rm -r $(OUTPUTDIR)/*
	-rm $(SRC_JSDIR)/combined.js

.PHONY: all clean javascript css deploy-pages
