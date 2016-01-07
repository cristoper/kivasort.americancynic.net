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

CPPFLAGS := -x c -P

all: javascript css $(DST_ROOT_FILES)

javascript: $(DST_JSDIR)/main.js $(DST_JSDIR)/ks/kiva_sort.js

css: $(DST_CSSDIR)/main.css

# Preprocess main.js to include cached JSON from Kiva.org
$(DST_JSDIR)/main.js: $(SRC_JSDIR)/main.js | $(DST_JSDIR)
	$(CPP) $(CPPFLAGS) $< -o $@

$(DST_JSDIR)/ks/kiva_sort.js: $(SRC_JSDIR)/ks/kiva_sort.js | $(DST_JSDIR)
	mkdir -p $(DST_JSDIR)/ks/
	cp $< $@

$(DST_CSSDIR)/main.css: $(SRC_CSSDIR)/main.css | $(DST_CSSDIR)
	cp $< $@

$(OUTPUTDIR):
	test -d $(OUTPUTDIR) || mkdir $@

$(DST_JSDIR): |$(OUTPUTDIR)
	test -d $(DST_JSDIR) || mkdir $@

$(DST_CSSDIR): |$(OUTPUTDIR)
	test -d $(DST_CSSDIR) || mkdir $@

clean:
	-rm -r $(OUTPUTDIR)/*

# Copy everything in root/ to output/
$(DST_ROOT_FILES): output/%: root/%|$(OUTPUTDIR)
	cp $< $(OUTPUTDIR)

.PHONY: all clean javascript
