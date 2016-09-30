# frozen_string_literal: true
class HomesController < WebController
  before_action :authenticate_user!

  def index
    @homes = policy_scope(Home)
  end

  def show
    @home = Home.find(params[:id])
    authorize @home

    @readings = @home.readings.take(10)

    @temperature = []
    @humidity = []

    @home.sensors.each do |sensor|
      name = sensor.room_name ? sensor.room_name : "unnamed"
      @temperature << { name: name, data: temperature_data(sensor) }
      @humidity << { name: name, data: humidity_data(sensor) }
    end
  end

  def new
    authorize :home
    @home = Home.new
  end

  def create
    @home = Home.new(home_params)
    authorize @home
    @home.save!
    redirect_to @home
  end

  def edit
    @home = Home.find(params[:id])
    authorize @home
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to homes_path
  end

  def update
    @home = Home.find(params[:id])
    authorize @home
    @home.update(home_params)
    @home.save!
    redirect_to @home
  end

  def destroy
    @home = Home.find(params[:id])
    authorize @home
    @home.destroy!
    redirect_to homes_path
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to homes_path
  end

  private

  def home_params
    params[:home].permit(permitted_home_params).merge(
      owner_id: current_user.id
    )
  end

  def permitted_home_params
    %i(name)
  end

  def temperature_data(sensor)
    Reading.temperature
           .where(sensor: sensor)
           .where(["created_at >= ?", 1.day.ago])
           .pluck(:created_at, :value)
  end

  def humidity_data(sensor)
    Reading.humidity
           .where(sensor: sensor)
           .where(["created_at >= ?", 1.day.ago])
           .pluck(:created_at, :value)
  end
end
