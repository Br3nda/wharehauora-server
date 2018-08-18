// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function setupRoomDataReloader(room_id) {
  $('.room-' + room_id + '-list').hide();
  getRoomData(room_id);
}


function getRoomData(room_id) {
  let url = '/api/v1/rooms/' + room_id + '.json';
  $.get( url )
    .done(function(response) {
      updateRoomDisplay(room_id, response.data);
    })
    .fail(function(response, data) {
      displayErrorForRoom(room_id);
    });
}


function displayErrorForRoom(room_id, data) {
  let keys = ['temperature', 'humidity', 'dewpoint'];
  keys.forEach(function(key, index) {
    let div = '#room-' + room_id + '-' + key + '-';
    $(div + 'value').text('ERROR');
  });
}

function updateRoomDisplay(room_id, data) {
  let keys = ['temperature', 'humidity', 'dewpoint'];

  let readings = data.attributes.readings;

  keys.forEach(function(key, index) {
    let reading = readings[key];
    let div = '#room-' + room_id + '-' + key + '-';
    if (reading) {

      // Show the value
      $(div + 'value').text(reading.value + reading.unit);

      // Show the timestamp of the readings
      $(div +'timestamp').attr('datetime', reading.timestamp);
      jQuery(div +'timestamp').timeago();

      // Mark whether this reading is current or old
      let current_reading_div = $('#room-' + room_id + '-no-' + key);
      if(reading.current) current_reading_div.hide();
      else current_reading_div.show();
    } else {
      $(div + 'value').text('??');
      $(div +'timestamp').text('No data');
    }
  });

  // Sets the class on the room card, blue/green
  let conditions_table = $('#room-' + room_id + '-table');
  if(data.attributes.ratings.good) {
    conditions_table.addClass('conditions-table-good').removeClass('conditions-table-bad');
  } else {
    conditions_table.addClass('conditions-table-bad').removeClass('conditions-table-good');
  }

  let div = '#room-' + room_id + '-';

  let too_cold_div = $(div + 'too-cold');
  if(data.attributes.ratings.too_cold) too_cold_div.show();
  else too_cold_div.hide();

  let too_hot_div = $(div + 'too-hot');
  if(data.attributes.ratings.too_hot) too_hot_div.show();
  else too_hot_div.hide();

  let no_sensors_div = $(div + 'no-sensors');
  if(data.attributes.sensor_count === 0) no_sensors_div.show();
  else no_sensors_div.hide();

  $('.room-' + room_id + '-list').show();
}
