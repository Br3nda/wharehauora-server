class ReadingsController < ApplicationController
  respond_to :json
  def index
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
    assemble_readings(@home.id, params[:key], params[:day])
    render json: @data
  end

  private

  def assemble_readings(home_id, key, data)
    @readings = readings(home_id, key, data)
    data_by_room = {}
    @readings.each do |reading|
      created_at, room_id, room_name, reading_value = reading
      room_name = 'un-named room' unless room_name
      data_by_room[room_id] = { 'name' => room_name, 'data' => [] } unless data_by_room[room_id]
      data_by_room[room_id]['data'] << [created_at, reading_value]
    end
    @data = flatten_readings_for_kickchart(data_by_room)
  end

  def flatten_readings_for_kickchart(data_by_room)
    data = []
    data_by_room.each do |_key, room|
      data << room
    end
    data
  end

  def readings(home_id, key, day)
    Reading
      .joins(:room)
      .where('readings.created_at::date = ?', day)
      .where("rooms.home_id": home_id)
      .where(key: key)
      .normal_range
      .order('readings.created_at')
      .pluck("date_trunc('minute', readings.created_at)",
             'rooms.id as room_id', 'rooms.name', :value)
  end
end
