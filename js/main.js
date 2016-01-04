$(document).ready(function () {
    var table = $('#KivaSort').makeKivaTable({
        deferRender: true,
        responsive: true,
        fixedHeader: true,
        dom: 'Bftip',
        buttons: ['pageLength', 'colvis', 'copy', 'csv', 'pdf'],

        /* Sort by Portfolio Yield, then Profitability */
        order: [[2, "asc"], [3, "asc"], [4, "desc"], [5, "desc"]]
    }).DataTable();

    $('#tabs').tabs({
        activate: function(e, ui) {
            if (ui.newTab.is($('#fpd_link'))) {
                // If the user is on a different tab when the table data loads,
                // then the Responsive plugin will not calculate column widths
                // correctly. So we recalculate them when the tab becomes
                // visible.
                table.responsive.recalc();
            }
        }
    });

    table.on('processing.dt', function() {
        // Initially hide/show incomplete rows based on HTML
        toggleIncomplete($('#hideIncomplete').is(':checked'));
        toggleInactive($('#hideInactive').is(':checked'));
    });

    // hide/show incomplete rows whenever checkbox is clicked
    $('#hideIncomplete').click(function() {
        toggleIncomplete(this.checked);
    });

    // hide/show inactive rows whenever checkbox is clicked
    $('#hideInactive').click(function() {
        toggleInactive(this.checked);
    });

    function toggleIncomplete(isChecked) {
        if (isChecked) {
            table.columns('th').search('^(?!-$)', true, false).draw();
        } else{
            table.columns('th').search('.', true).draw();
        }
    }

    function toggleInactive(isChecked) {
        if (isChecked) {
            table.columns('#statusCol').search('^active', true).draw();
        } else {
            table.columns('#statusCol').search('.', true).draw();
        }
    }

});
