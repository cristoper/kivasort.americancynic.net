$(document).ready(function () {
    $('#tabs').tabs();

    var table = $('#KivaSort').makeKivaTable({
        scrollY: 300,
        autoWidth: true,
        scrollX: true,
        dom: 'C<"clear">lfrtip', // ColVis plugin

        /* Sort by Portfolio Yield, then Profitability */
        order: [[3, "desc"], [2, "desc"]]
    }).DataTable();

    table.on('column-visibility.dt', function() {
        $.fn.dataTable.ColVis.fnRebuild();
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
