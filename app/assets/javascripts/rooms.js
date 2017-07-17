// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function updateRoom(room_id, key) {
  $.get( "/rooms/" + room_id + "/measurement.json?key=" + key, function( data ) {
    var div = '#room-' + room_id + "-" + key;
    $(div).text(data['value'] + data['unit']);
  });
}
