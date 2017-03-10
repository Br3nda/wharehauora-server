function todayMinusDays() {
    var numdays = $("#since").val();

    var datesince = moment().subtract(numdays, 'days').format('YYYY-MM-DD');
    var dateto = moment().format('YYYY-MM-DD');

    $("#datesince").val(datesince);
    $("#dateto").val(dateto);

    return 0
}

function clearSince() {
    $("#since").val("");
    return 0;
}
