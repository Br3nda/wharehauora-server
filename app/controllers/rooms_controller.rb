class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[show edit destroy update]
  before_action :set_home, only: %i[index edit update]

  respond_to :html

  def index
    authorize @home
    @rooms = policy_scope(Room)
             .where(home_id: @home.id)
             .includes(:room_type)
             .order(:name)
             .paginate(page: params[:page])

    @unassigned_sensors = @home.sensors.where(room_id: nil)
    respond_with(@rooms)
  end

  def show
    skip_authorization if @room.public?
    parse_dates
    @home = @room.home
    @keys = %w[temperature humidity]
    @start = 7.days.ago
    # @rating = @room.rating
    # @rating_text = rating_text
    respond_with(@room)
  end

  def edit
    respond_with(@room)
  end

  def update
    @room.update(room_params)
    redirect_to home_rooms_path(@home)
  end

  def destroy
    if @room.sensors.empty?
      ActiveRecord::Base.transaction do
        Reading.where(room_id: @room.id).delete_all
        @room.destroy
      end
    end
    redirect_to home_rooms_path(@room.home)
  end

  private

  def set_home
    @home = if @room
              @room.home
            else
              policy_scope(Home).find(params[:home_id])
            end
    authorize @home
  end

  def set_room
    @room = policy_scope(Room).find(params[:id])
    authorize @room
  end

  def room_params
    params[:room].permit(permitted_room_params)
  end

  def permitted_room_params
    %i[name room_type_id]
  end

  def parse_dates
    @day = params[:day]
    @day = Date.yesterday if @day.blank?
  end

  def rating_text # rubocop:disable Metrics/MethodLength
    case @rating
    when 'A'
      'excellent'
    when 'B'
      'good'
    when 'C'
      'barely acceptable'
    when 'D'
      'bad'
    when 'F'
      'very bad'
    else
      'unknown'
    end
  end
end
