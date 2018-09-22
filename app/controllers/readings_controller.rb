# frozen_string_literal: true

class ReadingsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json
  before_action :set_home
  before_action :set_room

  def index
    assemble_readings(params[:key])
    render json: @data
  end

  private

  def set_home
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home, :show?
  end

  def set_room
    return unless params[:room_id].present?
    @room = policy_scope(Room).find(params[:room_id])
    authorize @room, :show?
  end

  def assemble_readings(key)
    @readings = readings(key)
    data_by_room = {}
    @readings.each do |reading|
      created_at, room_id, room_name, reading_value = reading
      room_name ||= 'un-named room'
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

  def readings(key)
    Rails.cache.fetch("#{@room.id}/#{key}/readings", expires_in: 5.minutes) do
      Reading
        .joins(:room)
        .where("rooms.home_id": @room.home.id, key: key, room: @room)
        .order('readings.created_at')
        .limit(1000)
        .pluck("date_trunc('minute', readings.created_at)",
               'rooms.id as room_id', 'rooms.name', :value)
    end
  end
end
