# frozen_string_literal: true
class SensorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sensors = policy_scope(Sensor)
  end

  def show
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor

    @readings = @sensor.readings
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 50)

    @temperature = temperature_data
    @humidity = humidity_data
  end

  def edit
    @sensor = policy_scope(Sensor).find(params[:id])
    @room_types = RoomType.all
    authorize @sensor
  end

  def update
    sensor = policy_scope(Sensor).find(params[:id])
    authorize sensor
    sensor.update(sensor_params)
    sensor.save!
    redirect_to sensor.home
  end

  private

  def sensor_params
    params[:sensor].permit(permitted_sensor_params)
  end

  def permitted_sensor_params
    %i(
      room_name
      room_type_id
    )
  end

  def temperature_data
    time_series Reading.temperature
  end

  def humidity_data
    time_series Reading.humidity
  end

  def time_series(query)
    policy_scope(query).where(sensor_id: @sensor.id)
                       .where(['readings.created_at >= ?', 1.day.ago])
                       .pluck("date_trunc('minute', readings.created_at)", :value)
  end
end
