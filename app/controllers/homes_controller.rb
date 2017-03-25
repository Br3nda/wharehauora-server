# frozen_string_literal: true
class HomesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_home, only: [:show, :edit, :destroy, :update]
  respond_to :html

  def index
    authorize :home
    @homes = policy_scope(Home)
             .includes(:home_type, :owner)
             .order(:name)
             .paginate(page: params[:page])
    respond_with(@homes)
  end

  def show
    parse_dates
    @keys = %w(temperature humidity)
    # set_rooms
    # set_temp_and_humidity_data
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
    @day = params[:day]
    @day = Date.yesterday if @day.blank?
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

  def set_rooms
    @rooms = policy_scope(Room).where(home_id: @home.id).limit(10)
  end

  def set_home
    @home = policy_scope(Home).find(params[:id])
    authorize @home
  end

  # def set_temp_and_humidity_data
  #   @data = {}
  #   Reading
  #     .joins(:room)
  #     .where('readings.created_at::date >= ? AND readings.created_at::date <= ?', @day, @day)
  #     .where("rooms.home_id": @home.id)
  #     .where("key IS NOT NULL")
  #     .order("readings.created_at")
  #     .pluck("date_trunc('minute', readings.created_at)", "rooms.name", :key, :value).each do |reading|

  #     created_at, room_name, reading_type, reading_value = reading
  #     @data[reading_type] = {} unless @data[reading_type]
  #     @data[reading_type][room_name] = [] unless @data[reading_type][room_name]
  #     @data[reading_type][room_name] << [created_at, reading_value]
  #   end
  #   puts @data
  # end
end
