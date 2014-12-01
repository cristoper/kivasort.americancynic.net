$(document).ready(function () {
    var table = $('#KivaSort').makeKivaTable({
        scrollY: 300,
        autoWidth: true,
        scrollX: true,
        dom: 'C<"clear">lfrtip' // ColVis plugin
    }).DataTable();

    table.on('column-visibility.dt', function() {
        $.fn.dataTable.ColVis.fnRebuild();
    });

    $('#tabs').tabs();
});
