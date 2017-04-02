class Opendata::ReadingsController < ApplicationController
  respond_to :json
  after_action :skip_authorization
  def index
    assemble_readings(params[:key], params[:day])
    render json: @data
  end

  private

  def assemble_readings(key, day)
    @readings = {}
    readings_by_room_type(key, day).each do |reading|
      part, value = reading
      room_type, timestamp = part
      @readings[room_type] = { 'name' => room_type, 'data' => [] } unless @readings[room_type]
      @readings[room_type]['data'] << [timestamp, value]
    end
    @data = flatten_readings_for_kickchart(@readings)
  end

  def flatten_readings_for_kickchart(readings)
    data = []
    readings.each do |_key, room|
      data << room
    end
    data
  end

  def readings_by_room_type(key, day)
    Reading.joins(:room, room: :room_type)
           .where('readings.created_at::date = ?', day)
           .where(key: key)
           .group('room_types.name', "date_trunc('hour', readings.created_at)")
           .median(:value)
  end
end
