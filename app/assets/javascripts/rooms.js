// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function setupRoomDataReloader(room_id) {
  console.log("setting up data reloader");
  $('.room-' + room_id + '-list').hide();
  setInterval(function() { getRoomData(room_id); }, 45*1000);
  getRoomData(room_id);

}


function getRoomData(room_id) {
  console.log("Getting room data");
  $.get( "/api/rooms/" + room_id + ".json", function( response ) {
    updateRoomDisplay(room_id, response.data);
  });
}


function updateRoomDisplay(room_id, data) {
  console.log("Updating room display");
  console.log(data);
  var keys = ['temperature', 'humidity', 'dewpoint'];

  var readings = data.attributes.readings;
  keys.forEach(function(key, index) {
    console.log(key);
    var reading = readings[key];
    var div = '#room-' + room_id + "-" + key + "-";
    if (reading) {

      // show the value
      $(div + "value").text(reading.value + reading.unit);

      // show the timestamp of the readings
      $(div +"timestamp").attr('datetime', reading.timestamp);
      jQuery(div +"timestamp").timeago();

      // mark whether this reading is current or old
      var current_reading_div = $("#room-" + room_id + "-no-" + key);
      if(reading.current) current_reading_div.hide();
      else current_reading_div.show();
    }
    else {
      $(div + "value").text("??");
      $(div +"timestamp").text("No data");
    }
  });

  // Sets the class on the room card, blue/green
  var conditions_table = $("#room-" + room_id + "-table");
  if(data.attributes.ratings.good) {
    conditions_table.addClass('conditions-table-good').removeClass('conditions-table-bad');
  } else {
    conditions_table.addClass('conditions-table-bad').removeClass('conditions-table-good');
  }

  var div = '#room-' + room_id + "-";

  var too_cold_div = $(div + "too-cold");
  if(data.attributes.ratings.too_cold) too_cold_div.show();
  else too_cold_div.hide();

  var too_hot_div = $(div + "too-hot");
  if(data.attributes.ratings.too_hot) too_hot_div.show();
  else too_hot_div.hide();

  var no_sensors_div = $(div + "no-sensors");
  if(data.attributes.sensor_count === 0) no_sensors_div.show();
  else no_sensors_div.hide();

  $('.room-' + room_id + '-list').show();
}
