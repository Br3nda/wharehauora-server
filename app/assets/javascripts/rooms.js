// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function updateRoom(room_id, key) {
  $.get( "/rooms/" + room_id + "/measurement.json?key=" + key, function( data ) {
    var div = '#room-' + room_id + "-" + key;
    $(div + "-value").text(data.value + data.unit);

    // time stamp
    // $(div +"-timestamp").text(data.timestamp);
    // magical time ago
    $(div +"-timestamp").attr('datetime', data.timestamp);

    if(data.opinions.good) {
      $("#room-"+room_id+"-table").addClass('conditions-table-good');
      $("#room-"+room_id+"-table").removeClass('conditions-table-bad');
    }
    else {
      $("#room-"+room_id+"-table").addClass('conditions-table-bad');
      $("#room-"+room_id+"-table").removeClass('conditions-table-good');
    }

    var div = '#room-' + room_id + "-"

    if(data.opinions.too_cold) {
      $(div +"too-cold").show();
    }
    else {
      $(div +"too-cold").hide();
    }

    if(data.opinions.too_hot) {
      $(div +"too-hot").show();
    }
    else {
      $(div +"too-hot").hide();
    }

    if(data.sensor_count === 0) {
      $(div +"no-sensors").show();
    }
    else {
      $(div +"no-sensors").hide();
    }

    if(data.current) {
      $(div +"no-" + key).hide();
    }
    else {
      $(div +"no-" + key).show();
    }
  });
}
