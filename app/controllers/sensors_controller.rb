# frozen_string_literal: true
class SensorsController < WebController
  before_action :authenticate_user!
  def index
    @sensors = policy_scope(Sensor)
  end

  def show
    @sensor = Sensor.find(params[:id])
    authorize @sensor
  end

  def new
    @room = Room.find(params[:room_id])
    authorize @room
    @sensor = Sensor.new(room_id: @room.id)
  end
end
