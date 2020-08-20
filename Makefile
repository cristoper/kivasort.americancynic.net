ROOTDIR := root
OUTPUTDIR := output
SRC_JSDIR := js
SRC_CSSDIR := css
DST_JSDIR = $(OUTPUTDIR)/$(SRC_JSDIR)
DST_CSSDIR = $(OUTPUTDIR)/$(SRC_CSSDIR)
THEME := redmond

MODS = node_modules
ROOT_FILES = $(wildcard $(ROOTDIR)/*)
DST_ROOT_FILES = $(patsubst root/%, $(OUTPUTDIR)/%, $(ROOT_FILES))

UGLIFY := $(MODS)/uglify-js/bin/uglifyjs
UGLYFLAGS := --compress --mangle

CLEANCSS := $(MODS)/clean-css-cli/bin/cleancss

PP := m4
PPFLAGS := --prefix-builtins -DTHEME=$(THEME) $(if $(DEBUG_MODE), -DDEBUG_MODE)
# To enable use of pre-fetched partners.json use:
PPFLAGS += $(if $(NO_AJAX), -Dno_ajax)

JS_DT := $(addprefix $(MODS)/datatables.net, \
/js/jquery.dataTables.js \
-jqui/js/dataTables.jqueryui.js \
-buttons/js/dataTables.buttons.js \
-buttons/js/buttons.colVis.js \
-buttons/js/buttons.html5.js \
-buttons-jqui/js/buttons.jqueryui.js \
-fixedheader/js/dataTables.fixedHeader.js \
-responsive/js/dataTables.responsive.js)

JS_UI := $(addprefix $(MODS)/jquery-ui/ui/, \
core.js \
widget.js \
/widgets/tabs.js \
/widgets/mouse.js \
/widgets/slider.js \
/widgets/datepicker.js)

JS_FILES = \
$(MODS)/jquery/dist/jquery.js \
$(JS_DT) \
$(JS_UI) \
$(MODS)/jquery-ui-slider-pips/dist/jquery-ui-slider-pips.js \
$(MODS)/datatables-filterwidgets/datatables-filterwidgets.js \
$(MODS)/jquery-kivasort/kiva_sort.js \
$(SRC_JSDIR)/main.js

CSS_DT := $(addprefix $(MODS)/datatables.net, \
-jqui/css/dataTables.jqueryui.css \
-buttons-jqui/css/buttons.jqueryui.css \
-fixedheader-jqui/css/fixedHeader.jqueryui.css \
-responsive-jqui/css/responsive.jqueryui.css)

CSS_FILES = $(MODS)/jquery-ui-themes/themes/$(THEME)/jquery-ui.css \
	    $(MODS)/jquery-ui-slider-pips/dist/jquery-ui-slider-pips.css \
	    $(CSS_DT) $(SRC_CSSDIR)/combined.css.in $(SRC_CSSDIR)/main.css

all: $(OUTPUTDIR)/index.html $(DST_ROOT_FILES) javascript css

javascript: $(DST_JSDIR)/combined.js $(SRC_JSDIR)/partners.json

css: $(DST_CSSDIR)/combined.css $(DST_CSSDIR)/images

deploy-pages: all
	sh deploy-to-pages.sh

$(OUTPUTDIR)/index.html: index.html \
    $(DST_JSDIR)/combined.js $(DST_CSSDIR)/combined.css | $(OUTPUTDIR)
	$(PP) $(PPFLAGS) $< > $@

# Concatenate JavaScript
# If $(DEBUG_MODE) is defined, then don't compress (ie: make DEBUG_MODE=yes)
$(DST_JSDIR)/combined.js: $(SRC_JSDIR)/combined.js.in $(JS_FILES) | $(DST_JSDIR)
	$(PP) $(PPFLAGS) $< > $@
	$(if $(DEBUG_MODE),,$(UGLIFY) $@ $(UGLYFLAGS) -o $@)

$(DST_CSSDIR)/combined.css: $(SRC_CSSDIR)/combined.css.in $(CSS_FILES) | $(DST_CSSDIR)
	$(PP) $(PPFLAGS) $< > $@
	$(if $(DEBUG_MODE),,$(CLEANCSS) $@ -o $@)

$(DST_CSSDIR)/images:  $(MODS)/jquery-ui-themes/themes/$(THEME)/images
	cp -r $< $@

$(SRC_JSDIR)/partners.json:
	$(MODS)/jquery-kivasort/fetchkivajson.js > $@

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
