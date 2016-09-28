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

  def create
    room = Room.find(params[:room_id])
    authorize room
    sensor = Sensor.new(sensor_params.merge(room_id: room.id))
    sensor.save!
    redirect_to room.home
  end

  private

  def sensor_params
    params[:sensor].permit(permitted_sensor_params)
  end

  def permitted_sensor_params
    %i(
      name
      home_id
    )
  end
end
