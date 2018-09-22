# frozen_string_literal: true

class SensorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sensor, only: %i[show edit update]
  respond_to :html

  def show
    respond_with(@sensor)
  end

  def edit
    @rooms = @sensor.home.rooms.order(:name)
  end

  def update
    if sensor_params_contains_room?
      @sensor.create_room! room_params
      @sensor.save!
    else
      @sensor.update!(sensor_params)
    end
    redirect_to home_rooms_path @sensor.home
  end

  def unassign
    @sensor = policy_scope(Sensor).find(params[:sensor_id])
    authorize @sensor
    room = @sensor.room
    @sensor.update! room: nil
    respond_with room
  end

  private

  def set_sensor
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor
  end

  def sensor_params
    params.require(:sensor).permit(:room_id)
  end

  def sensor_params_contains_room?
    params[:sensor][:room][:name].present?
  end

  def room_params
    params.require(:sensor).require(:room).permit(:name).merge(home_id: @sensor.home_id)
  end
end
