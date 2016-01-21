ROOTDIR := root
OUTPUTDIR := output
SRC_JSDIR := js
SRC_CSSDIR := css
DST_JSDIR = $(OUTPUTDIR)/$(SRC_JSDIR)
DST_CSSDIR = $(OUTPUTDIR)/$(SRC_CSSDIR)
THEME := redmond

ROOT_FILES = $(wildcard $(ROOTDIR)/*)
DST_ROOT_FILES = $(patsubst root/%, $(OUTPUTDIR)/%, $(ROOT_FILES))

UGLIFY := node_modules/uglify-js/bin/uglifyjs
UGLYFLAGS := --compress --mangle

PP := m4
PPFLAGS := --prefix-builtins -DTHEME=$(THEME) $(if $(DEBUG_MODE), -DDEBUG_MODE)
# To enable use of pre-fetched partners.json use:
PPFLAGS += $(if $(NO_AJAX), -Dno_ajax)

JS_DT := $(addprefix bower_components/datatables.net, \
/js/jquery.dataTables.js \
-jqui/js/dataTables.jqueryui.js \
-buttons/js/dataTables.buttons.js \
-buttons/js/buttons.colVis.js \
-buttons/js/buttons.html5.js \
-buttons-jqui/js/buttons.jqueryui.js \
-colreorder/js/dataTables.colReorder.js \
-fixedheader/js/dataTables.fixedHeader.js \
-responsive/js/dataTables.responsive.js)

JS_UI := $(addprefix bower_components/jquery-ui/ui/, \
core.js \
widget.js \
mouse.js \
tabs.js \
slider.js \
datepicker.js)

JS_FILES = \
bower_components/jquery/dist/jquery.js \
$(JS_DT) \
$(JS_UI) \
bower_components/jquery-kivasort/kiva_sort.js \
$(SRC_JSDIR)/main.js

CSS_DT := $(addprefix bower_components/datatables.net, \
-jqui/css/dataTables.jqueryui.css \
-buttons-jqui/css/buttons.jqueryui.css \
-colreorder-jqui/css/colReorder.jqueryui.css \
-fixedheader-jqui/css/fixedHeader.jqueryui.css \
-responsive-jqui/css/responsive.jqueryui.css)

CSS_FILES = bower_components/jquery-ui/themes/$(THEME)/jquery-ui.css \
	    $(CSS_DT) $(SRC_CSSDIR)/combined.css.in $(SRC_CSSDIR)/main.css

all: $(OUTPUTDIR)/index.html $(DST_ROOT_FILES) javascript css

javascript: $(DST_JSDIR)/combined.js $(SRC_JSDIR)/partners.json

css: $(DST_CSSDIR)/combined.css $(DST_CSSDIR)/images

deploy-pages: all
	sh deploy-to-pages.sh

$(OUTPUTDIR)/index.html: index.html javascript css | $(OUTPUTDIR)
	$(PP) $(PPFLAGS) $< > $@

# Concatenate JavaScript
# If $(DEBUG_MODE) is defined, then don't compress (ie: make DEBUG_MODE=yes)
$(DST_JSDIR)/combined.js: $(SRC_JSDIR)/combined.js.in $(JS_FILES) | $(DST_JSDIR)
	$(PP) $(PPFLAGS) $< > $@
	$(if $(DEBUG_MODE),,$(UGLIFY) $@ $(UGLYFLAGS) -o $@)

$(DST_CSSDIR)/combined.css: $(SRC_CSSDIR)/combined.css.in $(CSS_FILES) | $(DST_CSSDIR)
	$(PP) $(PPFLAGS) $< > $@

$(DST_CSSDIR)/images:  bower_components/jquery-ui/themes/$(THEME)/images
	cp -r $< $@

$(SRC_JSDIR)/partners.json:
	bower_components/jquery-kivasort/fetchkivajson.js > $@

$(DST_JSDIR)/partners.json: $(SRC_JSDIR)/partners.json
	@# Only copy to output/ if no_ajax is specified
	$(if $(NO_AJAX), cp $< $@)

$(OUTPUTDIR) $(DST_JSDIR) $(DST_CSSDIR):
	test -d $@ || mkdir $@

# Copy everything in root/ to output/
$(DST_ROOT_FILES): output/%: root/%|$(OUTPUTDIR)
	cp $< $(OUTPUTDIR)

clean:
	-rm -r $(OUTPUTDIR)/*

.PHONY: all clean javascript css deploy-pages
