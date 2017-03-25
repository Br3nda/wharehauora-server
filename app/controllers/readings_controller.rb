class ReadingsController < ApplicationController
  respond_to :json
  def index
    parse_params
    assemble_readings
    flatten_readings_for_kickchart
  end

  private

  def parse_params
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
    @room = @home.rooms.find(params[:room_id]) if params[:room_id]
  end

  def assemble_readings
    # {name: goal.name, data: goal.feats.group_by_week(:created_at).count
    @rooms = {}
    readings.each do |reading|
      created_at, room_id, room_name, reading_value = reading
      room_name = 'un-named room' unless room_name
      @rooms[room_id] = { 'name' => room_name, 'data' => [] } unless @rooms[room_id]
      @rooms[room_id]['data'] << [created_at, reading_value]
    end
  end

  def flatten_readings_for_kickchart
    # flatten
    @data = []
    @rooms.each do |_key, room|
      @data << room
    end
    render json: @data
  end

  def readings
    query = Reading
            .joins(:room)
            .day_filter
            .where("rooms.home_id": @home.id)
            .where(key: params[:key])
    query = query.where("rooms.id": @room.id) if @room
    query.order('readings.created_at').pluck_data
  end

  def day_filter
    where('readings.created_at::date >= ? AND readings.created_at::date <= ?', params[:day], params[:day])
  end

  def pluck_data
    pluck("date_trunc('minute', readings.created_at)", 'rooms.id as room_id', 'rooms.name', :value)
  end
end
