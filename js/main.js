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
        }
    });


    kivaTable.on('init.dt', function(e, s, b) {
        // Keep reference to DataTable
        dTable = kivaTable.DataTable();

        // Initially hide/show incomplete rows based on HTML
        toggleIncomplete($('#hideIncomplete').is(':checked'));
        toggleInactive($('#hideInactive').is(':checked'));
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
            }
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

            /** To NOT use the cached json file, include -Dno_json in the
             * Makefiles CPPFLAGS */
            #ifndef no_json
            ks_partnerData:
                #include "partners.json"
            ,
            #endif


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
