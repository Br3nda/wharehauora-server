# frozen_string_literal: true
class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: [:show, :edit, :destroy, :update]
  respond_to :html

  def index
    authorize :home
    @homes = policy_scope(Home)
    respond_with(@homes)
  end

  def show
    parse_dates
    set_sensors
    set_temp_and_humidity_data
    respond_with(@home)
  end

  def new
    authorize :home
    @home = Home.new
    respond_with(@home)
  end

  def create
    @home = Home.new(home_params.merge(owner_id: current_user.id))
    authorize @home
    @home.save
    respond_with(@home)
  end

  def edit
    @home_types = HomeType.all
    respond_with(@home)
  end

  def update
    @home.update(home_params)
    @home.save!
    respond_with(@home)
  end

  def destroy
    @home.destroy
    respond_with(@home)
  end

  private

  def parse_dates
    @datesince = params[:datesince]
    @dateto = params[:dateto]

    @datesince = 1.day.ago if @datesince.blank?
    @dateto = Date.current if @dateto.blank?
  end

  def home_params
    params[:home].permit(permitted_home_params)
  end

  def permitted_home_params
    %i(
      name
      is_public
      home_type_id
    )
  end

  def temperature_data(room, datesince, dateto)
    time_series Reading.temperature, room, datesince, dateto
  end

  def humidity_data(room, datesince, dateto)
    time_series Reading.humidity, room, datesince, dateto
  end

  def time_series(query, room, datesince, dateto)
    query.where(room: room)
         .where(['created_at >= ?', datesince])
         .where(['created_at <= ?', dateto])
         .where('value < 120') # temp hack to filter the bogus readings
         .where('value > 0') # temp hack to filter the bogus readings
         .pluck("date_trunc('minute', created_at)", :value)
  end

  def set_sensors
    @sensors = policy_scope(Sensor).where(home_id: @home.id)
  end

  def set_home
    @home = policy_scope(Home).find(params[:id])
    authorize @home
  end

  def set_temp_and_humidity_data
    @temperature = []
    @humidity = []

    @home.rooms.each do |room|
      name = room.name ? room.name : 'unnamed'
      @temperature << { name: name, data: temperature_data(room, @datesince, @dateto) }
      @humidity << { name: name, data: humidity_data(room, @datesince, @dateto) }
    end
  end
end
