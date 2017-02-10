# frozen_string_literal: true
class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: [:show, :edit, :destroy, :update]

  def index
    authorize :home
    @homes = policy_scope(Home)
  end

  def show
    @temperature = []
    @humidity = []

    @home.rooms.each do |room|
      name = room.name ? room.name : 'unnamed'

      data = { name: name, data: temperature_data(room) }
      @temperature << data unless data.empty?

      data = { name: name, data: humidity_data(room) }
      @humidity << data unless data.empty?
    end
  end

  def new
    authorize :home
    @home = Home.new
    @home_types = HomeType.all
  end

  def create
    @home = Home.new(home_params.merge(owner_id: current_user.id))
    authorize @home
    @home.save!
    redirect_to @home
  end

  def edit
    @home_types = HomeType.all
  end

  def update
    @home.update(home_params)
    @home.save!
    redirect_to home_path(@home)
  end

  def destroy
    @home.destroy!
    redirect_to homes_path
  end

  private

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

  def temperature_data(room)
    time_series Metric.temperature, room
  end

  def humidity_data(room)
    time_series Metric.humidity, room
  end

  def time_series(query, room)
    query.where(room: room)
         .where(['created_at >= ?', 1.day.ago])
         .pluck("date_trunc('minute', created_at)", :value)
  end

  def set_home
    @home = policy_scope(Home).find(params[:id])
    authorize @home
  end
end
