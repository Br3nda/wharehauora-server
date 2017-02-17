function todayMinusDays() {
    numdays = $("#since").val();

    datesince = moment().subtract(numdays, 'days').format('YYYY-MM-DD');
    dateto = moment().format('YYYY-MM-DD')

    $("#datesince").val(datesince)
    $("#dateto").val(dateto)

    return 0
}

function clearSince() {
    $("#since").val("")

    return 0
}
