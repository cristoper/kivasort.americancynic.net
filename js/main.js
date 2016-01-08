// Change m4 quotes to something that doesn't ruin syntax highlighting or
// interfere with the rest of the file:
//changequote(`<<', `>>') 
undivert(<<node_modules/jquery-kivasort/kiva_sort.js>>)
$(document).ready(function () {

    var kivaTable = $('#KivaSort');
    var dTable;

    $('#tabs').tabs({
        activate: function(e, ui) {
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

    kivaTable.on('preXhr.dt', function(e, s, b) {
        // Style the loading row
        var loading = $('#loadingrow');
        var datadiv = $('#data');
        loading.css('width', datadiv.width());
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
            loadingRecords: '<div id="loadingrow" class="ui-widget ui-state-default">Loading... <img src="ajax-loader.gif"></div>'
        },
        buttons: [ 'pageLength',
            'colvis',  
            { extend: 'collection', text: 'Export',
                buttons: [
                    {extend: 'copy', text: 'Copy to Clipboard'},
                    { extend: 'csv', text: 'Download as CSV'},
                    { extend: 'json', text: 'View source JSON' }
                ]
            }],

            /** To NOT use the cached json file, include '-Dno_ajax' in the
             * Makefile PPFLAGS */
            ifdef(<<no_ajax>>, <<ks_partnerData: undivert(js/partners.json),>>)


        /* Sort by Portfolio Yield, then Profitability */
        order: [[2, "asc"], [3, "asc"], [4, "desc"], [5, "desc"]]
    });

    function toggleIncomplete(isChecked) {
        if (isChecked) {
            dTable.columns('th').search('^(?!-$)', true, false).draw();
        } else{
            dTable.columns('th').search('.', true).draw();
        }
    }

    function toggleInactive(isChecked) {
        if (isChecked) {
            dTable.columns('#statusCol').search('^active', true).draw();
        } else {
            dTable.columns('#statusCol').search('.', true).draw();
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
