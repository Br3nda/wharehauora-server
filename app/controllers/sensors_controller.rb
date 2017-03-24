class SensorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sensor, only: [:show, :edit, :destroy, :update]
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

  def show; end

  private

  def set_sensor
    @sensor = policy_scope(Sensor).find(params[:id])
    authorize @sensor
  end
end
