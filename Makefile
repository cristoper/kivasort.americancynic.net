ROOTDIR := root
OUTPUTDIR := output
SRC_JSDIR := js
SRC_CSSDIR := css
DST_JSDIR = $(OUTPUTDIR)/$(SRC_JSDIR)
DST_CSSDIR = $(OUTPUTDIR)/$(SRC_CSSDIR)

ROOT_FILES = $(wildcard $(ROOTDIR)/*)
DST_ROOT_FILES = $(patsubst root/%, $(OUTPUTDIR)/%, $(ROOT_FILES))

JS_FILES = $(wildcard $(SRC_JSDIR)/**/*.js)
CSS_FILES := $(wildcard $(SRC_CSSDIR)/*.css)

UGLIFY := node_modules/uglify-js/bin/uglifyjs
UGLYFLAGS := --compress --mangle

CPPFLAGS := -x c -w -P
# To enable use of pre-fetched partners.json use:
#CPPFLAGS := -x c -w -P -Dno_ajax

all: $(OUTPUTDIR)/index.html $(DST_ROOT_FILES) $(DST_CSSDIR)/main.css

$(OUTPUTDIR)/index.html: index.html $(DST_JSDIR)/combined.js
	$(CPP) $(CPPFLAGS) $< -o $@

# Combine main.js, partners.json, kiva_sort.js
# If $(DEBUG_MODE) is defined, then don't compress (ie: make DEBUG_MODE=yes)
$(DST_JSDIR)/combined.js: $(SRC_JSDIR)/main.js $(SRC_JSDIR)/ks/kiva_sort.js \
    | $(DST_JSDIR)
	$(CPP) $(CPPFLAGS) $< -o $@
	$(if $(DEBUG_MODE),,$(UGLIFY) $@ $(UGLYFLAGS) -o $@)

$(DST_CSSDIR)/main.css: $(SRC_CSSDIR)/main.css | $(DST_CSSDIR)
	cp $< $@

$(OUTPUTDIR) $(DST_JSDIR) $(DST_CSSDIR):
	test -d $@ || mkdir $@

clean:
	-rm -r $(OUTPUTDIR)/*

# Copy everything in root/ to output/
$(DST_ROOT_FILES): output/%: root/%|$(OUTPUTDIR)
	cp $< $(OUTPUTDIR)

.PHONY: all clean javascript css
