class SensorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sensor, only: %i[show edit destroy update]
  respond_to :html

  def index
    @home = policy_scope(Home).find(params[:home_id])
    authorize @home
    @sensors = @home.sensors
                    .includes(:room)
                    .order(:node_id)
                    .paginate(page: params[:page])
  end

  def destroy
    @sensor.destroy!
    redirect_to home_sensors_path(@sensor.home)
  end

  def show
    respond_with(@sensor)
  end

  def edit
    @rooms = @sensor.home.rooms.order(:name)
  end

  def update
    @sensor.update!(sensor_params)
    redirect_to home_sensors_path @sensor.home
  end

  private

  def set_sensor
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor
  end

  def sensor_params
    params.require(:sensor).permit(:room_id)
  end
end
