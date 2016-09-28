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
end
