# frozen_string_literal: true
class SensorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sensors = policy_scope(Sensor)
  end

  def show
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor

    @daysago = params[:since].to_i.day.ago

    @readings = getreadings @daysago
    @temperature = temperature_data @daysago
    @humidity = humidity_data @daysago
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

  def temperature_data(daysago)
    time_series Reading.temperature, daysago
  end

  def humidity_data(daysago)
    time_series Reading.humidity, daysago
  end

  def getreadings(daysago)
    @sensor.readings
           .where(['created_at >= ?', daysago])
           .order(created_at: :desc)
           .paginate(page: params[:page], per_page: 50)
  end

  def time_series(query, daysago = 1.day.ago)
    policy_scope(query).where(sensor_id: @sensor.id)
                       .where(['readings.created_at >= ?', daysago])
                       .pluck("date_trunc('minute', readings.created_at)", :value)
  end
end
