class ReadingsController < ApplicationController
  respond_to :json
  def index
    set_home
    set_room
    assemble_readings(@home, @room, params[:key])
    render json: @data
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
  end

  def set_room
    @room = policy_scope(Room).find(params[:room_id]) if params[:room_id]
  end

  def assemble_readings(home, room, key)
    @readings = readings(home, room, key)
    data_by_room = {}
    @readings.each do |reading|
      created_at, room_id, room_name, reading_value = reading
      room_name = 'un-named room' unless room_name
      data_by_room[room_id] = { 'name' => room_name, 'data' => [] } unless data_by_room[room_id]
      data_by_room[room_id]['data'] << [created_at, reading_value.round(2)]
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

  def date_filter(query)
    return query.where('readings.created_at >= ?', params[:start]) if params[:start]
    return query.where('readings.created_at::date = ?', params[:day]) if params[:day]
    query
  end

  def readings(home, room, key)
    conditions = { "rooms.home_id": home.id, key: key }
    conditions[:room_id] = room.id if room.present?
    date_filter(Reading)
      .joins(:room)
      .where(conditions)
      .normal_range
      .order('readings.created_at')
      .pluck("date_trunc('second', readings.created_at)",
             'rooms.id as room_id', 'rooms.name', :value)
  end
end
