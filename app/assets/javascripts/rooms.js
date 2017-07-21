// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function updateRoom(room_id) {
  $.get( "/rooms/" + room_id + "/summary.json", function( data ) {

    var keys = ['temperature', 'humidity', 'dewpoint'];

    keys.forEach(function(key, index, array) {
      var reading = data.readings[key];
      if (reading) {
        var div = '#room-' + room_id + "-" + key + "-";
        // show the value
        $(div + "value").text(reading.value + reading.unit);
        // show the timestamp of the readings
        $(div +"timestamp").text(reading.timestamp);

        // mark whether this reading is current or old
        var current_reading_div = $("#room-" + room_id + "-no-" + key);
        if(reading.current) current_reading_div.hide();
        else current_reading_div.show();
      }
    });

    // Sets the class on the room card, blue/green
    var conditions_table = $("#room-"+room_id+"-table");
    if(data.ratings.good) conditions_table.addClass('conditions-table-good').removeClass('conditions-table-bad');
    else  conditions_table.addClass('conditions-table-bad').removeClass('conditions-table-good');

    var div = '#room-' + room_id + "-";

    var too_cold_div = $(div +"too-cold");
    if(data.ratings.too_cold) too_cold_div.show();
    else too_cold_div.hide();

    var too_hot_div = $(div +"too-hot");
    if(data.ratings.too_hot) too_hot_div.show();
    else too_hot_div.hide();

    var no_sensors_div = $(div +"no-sensors");
    if(data.sensor_count === 0) no_sensors_div.show();
    else no_sensors_div.hide();

  });
}
