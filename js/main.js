// Change m4 quotes to something that doesn't ruin syntax highlighting or
// interfere with the rest of the file:
//m4_changequote(`<<', `>>')
$(document).ready(function () {

    window.onpopstate = function(event) {
        // Change tabs on back/forward buttons
        var hash = $(window.location.hash);
        if (window.location.hash == "") {
            hash = $("#data");
        }
        var index = hash.index() - 1;
        $('#tabs').tabs('option', 'active', index);
    };

    var kivaTable = $('#KivaSort');
    var dTable;

    $('#tabs').tabs({
        activate: function(e, ui) {

            /* Update URL bar to allow bookmarking of tabs and back/forward
            * buttons in browsers which support the History API */

            var hash = ui.newPanel.attr('id');

            if (e.originalEvent && e.originalEvent.type == "click") {
                if (window.location.protocol != "file:" && history.pushState) {
                    history.pushState(null, null, '#' + hash);
                } else {
                    /* At least allow non-History API browsers to bookmark tabs
                     * The scrollmem stuff is to prevent scrolling when setting the id
                     * fragment (see http://stackoverflow.com/a/3041606/408930) */
                    var scrollmem = $('html,body').scrollTop();
                    window.location.hash = hash;
                    $('html,body').scrollTop(scrollmem);
                }
            }

            if (ui.newTab.is($('#fpd_link'))) {
                // If the user is on a different tab when the table data loads,
                // then the Responsive plugin will not calculate column widths
                // correctly. So we recalculate them when the tab becomes
                // visible.
                dTable.responsive.recalc();

                // Re-enable the fixed header
                dTable.fixedHeader.enable(true);
            } else {
                // remove fixed header when viewing other tabs
                dTable.fixedHeader.enable(false);
            }
        },
        create: function() {
            $('#tabs').show();
            $('#loading').hide();
        }
    });

    kivaTable.on('init.dt', function(e, s, b) {
        // Keep reference to DataTable
        dTable = kivaTable.DataTable();

        // Initially hide/show incomplete rows based on HTML
        toggleIncomplete($('#hideIncomplete').is(':checked'));
        toggleInactive($('#hideInactive').is(':checked'));
    });

    kivaTable.on('xhr.dt', function() {
        $('#loading').hide();
    });

    kivaTable.on('preXhr.dt', function(e, s, b) {
        // Style the loading row
        var loading = $('#loading');
        var loadrow = $('#loadingrow');
        var datadiv = $('#data');
        loadrow.css('width', datadiv.width());
        datadiv.append(loading.show());
    });

    kivaTable.makeKivaTable({
        deferRender: true,
        responsive: true,
        fixedHeader: true,
        lengthMenu: [ [10, 25, 50, -1], [10, 25, 50, "All"] ],
        dom: 'Bftip',
        colReorder: true,
        language: {
            buttons: {
                pageLength: { '-1': "Show all rows", _: "Show %d rows/page" }
            },
            loadingRecords: '<div id="loadingrow">...</a>'
        },
        buttons: [ 'pageLength',
            'colvis',  
            { extend: 'collection', text: 'Export',
                buttons: [
                    {extend: 'copy', text: 'Copy to Clipboard'},
                    { extend: 'csv', text: 'Download as CSV'},
                    { extend: 'json', text: 'View source JSON' }
                ]
            }, 'reload'],

            /** To NOT use the cached json file, run make with 'NO_AJAX=y' */
            m4_ifdef(<<no_ajax>>, <<ks_partnerData: m4_undivert(js/partners.json),>>)


            /* Sort by Portfolio Yield, then Profitability */
            order: [[2, "asc"], [3, "asc"], [4, "desc"], [5, "desc"]]
    });

    function toggleIncomplete(isChecked) {
        if (isChecked) {
            dTable.columns('th').search('^(?!-$)', true, false).draw();
        } else{
            dTable.columns('th').search('', false, false).draw();
        }
    }

    function toggleInactive(isChecked) {
        if (isChecked) {
            dTable.columns('#statusCol').search('^active', true).draw();
        } else {
            dTable.columns('#statusCol').search('', false, false).draw();
        }
    }

    // hide/show incomplete rows whenever checkbox is clicked
    $('#hideIncomplete').click(function() {
        toggleIncomplete(this.checked);
    });

    // hide/show inactive rows whenever checkbox is clicked
    $('#hideInactive').click(function() {
        toggleInactive(this.checked);
    });

});
