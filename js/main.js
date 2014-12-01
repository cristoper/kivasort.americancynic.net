$(document).ready(function () {
    $('#tabs').tabs();

    var table = $('#KivaSort').makeKivaTable({
        scrollY: 300,
        autoWidth: true,
        scrollX: true,
        dom: 'C<"clear">lfrtip' // ColVis plugin
    }).DataTable();

    table.on('column-visibility.dt', function() {
        $.fn.dataTable.ColVis.fnRebuild();
    });

    table.on('processing.dt', function() {
        // Initially hide/show incomplete rows based on HTML
        toggleIncomplete($('#hideIncomplete').is(':checked'));
    });

    // hide/show incomplete rows whenever checkbox is clicked
    $('#hideIncomplete').click(function() {
        toggleIncomplete(this.checked);
    });

    function toggleIncomplete(isChecked) {
        if (isChecked) {
            table.columns('th').search('^(?!-$)', true, false).draw();
        } else{
            table.columns('th').search('.', true).draw();
        }
    }
});
