# frozen_string_literal: true
class SensorsController < WebController
  before_action :authenticate_user!
  def index
    @sensors = policy_scope(Sensor)
  end

  def show
    @sensor = Sensor.find(params[:id])
    authorize @sensor

    @readings = @sensor.readings
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 10)

    @temperature = temperature_data(@sensor)
    @humidity = humidity_data(@sensor)
  end

  def edit
    @sensor = Sensor.find(params[:id])
    authorize @sensor
  end

  def update
    sensor = Sensor.find(params[:id])
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
    )
  end

  def temperature_data(sensor)
    Reading.temperature
           .where(sensor: sensor)
           .limit(1000)
           .pluck(:created_at, :value)
  end

  def humidity_data(sensor)
    policy_scope(Reading.humidity)
      .where(sensor: sensor)
      .limit(1000)
      .pluck(:created_at, :value)
  end
end
